kea-dhcp6-server:
  pkg.installed:
    - pkgs:
      - kea-dhcp6-server
  service.running:
    - name: kea-dhcp6-server
    - enable: True
    - reload: False
    - sig: kea-dhcp6
    - watch:
      - pkg: kea-dhcp6-server
      - file: /etc/kea/kea-dhcp6.conf

/etc/kea/kea-dhcp6.conf:
  file.managed:
    - source: salt://kea-dhcp/files/kea-dhcp6.conf.j2
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}
        dhcp: {{ pillar['dhcp'] }}
    - require:
      - pkg: kea-dhcp6-server
