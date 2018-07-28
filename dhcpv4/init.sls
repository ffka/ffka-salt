include:
  - common.debian_testing

kea-dhcp4-server:
  pkg.installed:
    - fromrepo: testing
    - require:
      - pkgrepo: testing

kea-dhcp4-server.service:
  service.running:
    - enable: True
    - watch:
      - pkg: kea-dhcp4-server