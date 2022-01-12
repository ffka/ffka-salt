include:
  - dhcpv4.repo

/etc/apt/preferences.d/kea-common-kea-repo:
  file.managed:
    - contents: |
        Package: kea-common*
        Pin: release o=cloudsmith/isc/kea-2-0
        Pin-Priority: 800

/etc/apt/preferences.d/kea-dhcp4-server-kea-repo:
  file.managed:
    - contents: |
        Package: kea-dhcp4-*
        Pin: release o=cloudsmith/isc/kea-2-0
        Pin-Priority: 800

/etc/apt/preferences.d/kea-dhcp4-server-testing:
  file.absent


kea-common:
  pkg.installed:
    - require:
      - pkgrepo: kea-repo
#      - group: _kea@dhcp4
      - file: /etc/apt/preferences.d/kea-common-kea-repo

kea-dhcp4-server:
  pkg.installed:
    - require:
      - pkgrepo: kea-repo
#      - group: _kea@dhcp4
      - file: /etc/apt/preferences.d/kea-dhcp4-server-kea-repo

/etc/kea/kea-dhcp4.conf:
  file.managed:
    - source: salt://dhcpv4/files/dhcpv4.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: '0600'

/etc/systemd/system/kea-dhcp4-server.service.d/:
  file.directory:
    - mode: '0755'
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
    - mode: '0600'
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
