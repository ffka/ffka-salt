include:
  - common.debian_unstable

/etc/apt/preferences.d/kea-dhcp4-server-unstable:
  file.managed:
    - contents: |
        Package: kea-dhcp4-*
        Pin: release n=unstable
        Pin-Priority: 800

kea-dhcp4-server:
  pkg.installed:
    - fromrepo: unstable
    - require:
      - pkgrepo: unstable
      - file: /etc/apt/preferences.d/kea-dhcp4-server-unstable

/etc/kea/kea-dhcp4.conf:
  file.managed:
    - source: salt://dhcpv4/files/dhcpv4.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 600

/etc/systemd/system/kea-dhcp4-server.service.d/:
  file.directory:
    - mode: 755
    - makedirs: True
    - require:
      - pkg: kea-dhcp4-server

/etc/systemd/system/kea-dhcp4-server.service.d/create-lock-dir.conf:
  file.managed:
    - source: salt://dhcpv4/files/systemd/create-lock-dir.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - require:
      - file: /etc/systemd/system/kea-dhcp4-server.service.d/

kea-dhcp4-server.service:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - pkg: kea-dhcp4-server
      - file: /etc/kea/kea-dhcp4.conf
      - file: /etc/systemd/system/kea-dhcp4-server.service.d/create-lock-dir.conf
