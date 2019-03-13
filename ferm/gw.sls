/etc/ferm/conf.d/gw.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://ferm/files/gw.conf.j2
    - template: jinja
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}
    - require:
      - file: /etc/ferm/conf.d
    - watch_in:
      - service: ferm.service