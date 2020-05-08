# Connectivity between gwbats and backbone routers

/etc/bird/bird.d/50-internal-upstreams-basic.conf:
  file.managed:
    - source: salt://routing/files/bird2/gwbat/internal-upstreams.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: '0644'
    - require:
      - pkg: bird2
      - file: /etc/bird/bird.d/
    - watch_in:
      - service: bird.service

include:
  - routing.bird2.internal_upstream