/etc/bird/bird.d/20-basic-protocols-upstream-originator.conf:
  file.managed:
    - source:
      - salt://routing/files/bird2/bird.d/20-basic-protocols-upstream-originator.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: '0644'
    - watch_in:
      - service: bird.service
    - require:
      - pkg: bird2
      - file: /etc/bird/bird.d/