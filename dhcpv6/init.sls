include:
  - kea.kea-repo

/etc/apt/preferences.d/kea-dhcp6-server-kea-repo:
  file.managed:
    - contents: |
        Package: kea-dhcp6-*
        Pin: release o=cloudsmith/isc/kea-2-0
        Pin-Priority: 800

/etc/apt/preferences.d/kea-dhcp6-server-testing:
  file.absent

# This is a workaround for a bug in the installation script for kea
# 1.5.0~1 in debian unstable. To be removed once resolved.
# Also: change of user to root (change-user unit)
_kea@dhcp6:
  group.present:
    - name: _kea

kea-dhcp6-server:
  pkg.installed:
    - fromrepo: kea-repo
    - require:
      - pkgrepo: kea-repo
      - group: _kea@dhcp6
      - file: /etc/apt/preferences.d/kea-dhcp6-server-kea-repo

/etc/kea/kea-dhcp6.conf:
  file.managed:
    - source: salt://dhcpv6/files/dhcpv6.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: '0600'

/etc/systemd/system/kea-dhcp6-server.service.d/:
  file.directory:
    - mode: '0755'
    - makedirs: True
    - require:
      - pkg: kea-dhcp6-server

{% for unit in ["create-lock-dir", "change-user"] %}
/etc/systemd/system/kea-dhcp6-server.service.d/{{ unit }}.conf:
  file.managed:
    - source: salt://dhcpv6/files/systemd/{{ unit }}.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: '0600'
    - require:
      - file: /etc/systemd/system/kea-dhcp6-server.service.d/
{% endfor %}

kea-dhcp6-server.service:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - pkg: kea-dhcp6-server
      - file: /etc/kea/kea-dhcp6.conf
      - file: /etc/systemd/system/kea-dhcp6-server.service.d/create-lock-dir.conf