/etc/bird/bird6.d/35-vzffnrmo-loopback.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: 644
    - template: jinja
    - source: salt://routing/files/bird6.d/vzffnrmo-loopback.conf
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}
    - watch_in:
      - service: bird6
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/bird6.d
