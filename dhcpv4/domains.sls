/etc/kea/dhcp4-domains.conf:
  file.managed:
    - source: salt://dhcpv4/files/domains.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 600
