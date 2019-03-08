include:
  - common.debian_unstable

/etc/apt/preferences.d/kea-dhcp4-server-unstable:
  file.managed:
    - contents: |
        Package: kea-dhcp4-*
        Pin: release n=unstable
        Pin-Priority: 800

/etc/apt/preferences.d/kea-dhcp4-server-testing:
  file.absent

# This is a workaround for a bug in the installation script for kea
# 1.5.0~1 in debian unstable. To be removed once resolved.
# Also: change of user to root (change-user unit)
_kea@dhcp4:
  group.present:
    - name: _kea

kea-dhcp4-server:
  pkg.installed:
    - fromrepo: unstable
    - require:
      - pkgrepo: unstable
      - group: _kea@dhcp4
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

{% for unit in ["create-lock-dir", "change-user"] %}
/etc/systemd/system/kea-dhcp4-server.service.d/{{ unit }}.conf:
  file.managed:
    - source: salt://dhcpv4/files/systemd/{{ unit }}.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - require:
      - file: /etc/systemd/system/kea-dhcp4-server.service.d/
{% endfor %}

kea-dhcp4-server.service:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - pkg: kea-dhcp4-server
      - file: /etc/kea/kea-dhcp4.conf
      - file: /etc/systemd/system/kea-dhcp4-server.service.d/create-lock-dir.conf
