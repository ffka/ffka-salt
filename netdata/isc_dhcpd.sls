/etc/netdata/python.d/isc_dhcpd.conf:
  file.managed:
    - name: /etc/netdata/python.d/isc_dhcpd.conf
    - source: salt://netdata/files/isc_dhcpd.conf
