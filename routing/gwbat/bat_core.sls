# Connectivity between gwbats and core routers

/etc/bird/bird6.d/50-core.conf:
  file.managed:
    - source: salt://routing/files/bird6.d/gwbat/bat-core.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: 644
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/bird6.d
    - watch_in:
      - service: bird6