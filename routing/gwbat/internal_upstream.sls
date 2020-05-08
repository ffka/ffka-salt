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

/etc/bird/bird.d/12-kernel.conf:
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