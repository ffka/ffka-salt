# Connectivity between gwbats and backbone routers

/etc/bird/bird.d/12-gwbat-kernel.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: '0644'
    - template: jinja
    - source: salt://routing/files/bird2/gwbat/kernel.conf
    - watch_in:
      - service: bird.service
    - require:
      - pkg: bird2
      - file: /etc/bird/bird.d/

include:
  - routing.bird2.internal_upstream
