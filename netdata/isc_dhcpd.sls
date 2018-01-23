/etc/netdata/python.d/isc_dhcpd.conf:
  file.managed:
    - name: /etc/netdata/python.d/isc_dhcpd.conf
    - source: salt://isc_dhcpd.conf
