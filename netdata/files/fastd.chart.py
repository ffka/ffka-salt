# -*- coding: utf-8 -*-
# Description: fastd netdata python.d module
# Author: Julian Schuh (julez)

from bases.FrameworkServices.SocketService import SocketService

import json

# default module values
# update_every = 4
priority = 90000
retries = 60

ORDER = ['peers', 'net', 'net_packets']
CHARTS = {
    'peers': {
        'options': [None, 'All Active Peers', 'peers', 'peers', 'fastd.peers', 'line'],
        'lines': [['peers', 'peers', 'absolute']]
    },
    'net': {
        'options': [None, 'Bandwidth', 'kilobits/s', 'throughput', 'fastd.net', 'line'],
        'lines': [
            ['received', 'received', 'incremental', 8, 1024],
            ['sent', 'sent', 'incremental', -8, 1024],
            ['reordered', 'reordered', 'incremental', 8, 1024],
            ['dropped', 'dropped', 'incremental', -8, 1024],
            ['error', 'error', 'incremental', -8, 1024]
        ]
    },
    'net_packets': {
        'options': [None, 'Packets', 'packets/s', 'throughput', 'fastd.net_packets', 'line'],
        'lines': [
            ['packets_received', 'received', 'incremental', 1, 1],
            ['packets_sent', 'sent', 'incremental', -1, 1],
            ['packets_reordered', 'reordered', 'incremental', 1, 1],
            ['packets_dropped', 'dropped', 'incremental', -1, 1],
            ['packets_error', 'error', 'incremental', -1, 1]
        ]
    }
}


class Service(SocketService):
    def __init__(self, configuration=None, name=None):
        SocketService.__init__(self, configuration=configuration, name=name)
        self.order = ORDER
        self.definitions = CHARTS

        self.request = ""
        self.host = None
        self.port = None
        self.unix_socket = self.configuration.get('status_socket_path', None)

    def check(self):
        data = self.get_data()
        if data is None:
            return False
        return True

    def _check_raw_data(self, data):
        # socket will automatically closed after stats are written, so we dont need to close it early
        return False

    def get_data(self):
        try:
            raw = self._get_raw_data()
        except (ValueError, AttributeError):
            return None

        if raw is None:
            self.error("fastd status socket returned no data")
            return None

        try:
            fastd_data = json.loads(raw)
        except (ValueError, KeyError, TypeError):
            self.error("error parsing json returned from fastd status socket")
            return None

        peers_total = len(fastd_data.get("peers", {}).keys())

        return {
            'peers': peers_total,
            'received': fastd_data["statistics"]["rx"]["bytes"],
            'sent': fastd_data["statistics"]["tx"]["bytes"],
            'reordered': fastd_data["statistics"]["rx_reordered"]["bytes"],
            'dropped': fastd_data["statistics"]["tx_dropped"]["bytes"],
            'error': fastd_data["statistics"]["tx_error"]["bytes"],
            'packets_received': fastd_data["statistics"]["rx"]["packets"],
            'packets_sent': fastd_data["statistics"]["tx"]["packets"],
            'packets_reordered': fastd_data["statistics"]["rx_reordered"]["packets"],
            'packets_dropped': fastd_data["statistics"]["tx_dropped"]["packets"],
            'packets_error': fastd_data["statistics"]["tx_error"]["packets"],
        }