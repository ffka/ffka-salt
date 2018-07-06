/etc/ferm/conf.d/core.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://ferm/files/core.conf.j2
    - template: jinja
    - require:
      - file: /etc/ferm/conf.d