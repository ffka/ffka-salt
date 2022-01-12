include:
  - dhcpv4.repo

isc-kea-common:
  pkg.installed:
    - require:
      - pkgrepo: kea-repo
      - file: /etc/apt/preferences.d/isc-kea

isc-kea-dhcp4-server:
  pkg.installed:
    - require:
      - pkgrepo: kea-repo
      - file: /etc/apt/preferences.d/isc-kea

/etc/kea/kea-dhcp4.conf:
  file.managed:
    - source: salt://dhcpv4/files/dhcpv4.conf.j2
    - template: jinja
    - user: _kea
    - group: _kea
    - mode: '0600'
    - require:
      - pkg: isc-kea-dhcp4-server

isc-kea-dhcp4-server.service:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - pkg: isc-kea-dhcp4-server
      - file: /etc/kea/kea-dhcp4.conf
