kea-dhcp4-server:
  pkg.installed

kea-dhcp4-server.service:
  service.running:
    - enable: True
    - watch:
      - pkg: kea-dhcp4-server