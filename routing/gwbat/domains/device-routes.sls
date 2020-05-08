/etc/bird/bird.d/13-device-routes.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: '0644'
    - template: jinja
    - source: salt://routing/files/bird2/gwbat/domains-device-routes.conf
    - watch_in:
      - service: bird.service
    - require:
      - pkg: bird2
      - file: /etc/bird/bird.d/
