/etc/bird/bird6.d/61-gateway-bat.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: 644
    - template: jinja
    - source: salt://routing/files/bird6.d/gateway-bat.conf
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}
    - watch_in:
      - service: bird6
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/bird6.d
