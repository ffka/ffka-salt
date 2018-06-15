/etc/bird/bird6.d/30-core.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: 644
    - template: jinja
    - source: salt://routing/files/bird6.d/core.conf
    - watch_in:
      - service: bird6
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/bird6.d
