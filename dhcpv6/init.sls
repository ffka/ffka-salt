include:
  - common.debian_testing

/etc/apt/preferences.d/kea-dhcp6-server-testing:
  file.managed:
    - contents: |
        Package: kea-dhcp6-*
        Pin: release n=testing
        Pin-Priority: 800

kea-dhcp6-server:
  pkg.installed:
    - fromrepo: testing
    - require:
      - pkgrepo: testing
      - file: /etc/apt/preferences.d/kea-dhcp6-server-testing

/etc/kea/kea-dhcp6.conf:
  file.managed:
    - source: salt://dhcpv6/files/dhcpv6.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 600

kea-dhcp6-server.service:
  service.running:
    - enable: True
    - watch:
      - pkg: kea-dhcp6-server
      - file: /etc/kea/kea-dhcp6.conf