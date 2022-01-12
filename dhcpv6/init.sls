include:
  - dhcpv4.repo

isc-kea-dhcp6-server:
  pkg.installed:
    - require:
      - pkgrepo: kea-repo
      - file: /etc/apt/preferences.d/isc-kea

/etc/kea/kea-dhcp6.conf:
  file.managed:
    - source: salt://dhcpv6/files/dhcpv6.conf.j2
    - template: jinja
    - user: _kea
    - group: _kea
    - mode: '0600'
    - require:
      - pkg: isc-kea-dhcp6-server

isc-kea-dhcp6-server.service:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - pkg: isc-kea-dhcp6-server
      - file: /etc/kea/kea-dhcp6.conf
