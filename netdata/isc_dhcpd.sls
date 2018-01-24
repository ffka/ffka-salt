/etc/netdata/python.d/isc_dhcpd.conf:
  file.managed:
    - name: /etc/netdata/python.d/isc_dhcpd.conf
    - source: salt://netdata/files/isc_dhcpd.conf.j2
    - user: root
    - group: netdata
    - watch_in:
      - service: netdata.service

enable netdata isc_dhcpd:
  file.accumulated:
    - filename: /etc/netdata/python.d.conf
    - text: 'isc_dhcpd: yes'
    - require_in:
      - file: /etc/netdata/python.d.conf