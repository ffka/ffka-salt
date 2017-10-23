install Dependencies for ext-respondd:
  pkg.installed:
    - pkgs:
      - python3-netifaces
      - ethtool
      - lsb-release


get latest ext-respondd:
  git.latest:
    - name: https://github.com/ffka/ext-respondd
    - target: /opt/ext-respondd
    - force_clone: True

ext-respondd config.json:
  file.managed:
    - name: /opt/ext-respondd/config.json
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - source: salt://respondd/files/config.json.j2
    - template: jinja

ext-respondd alias.json:
  file.managed:
    - name: /opt/ext-respondd/alias.json
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - source: salt://respondd/files/alias.json.j2
    - template: jinja

/lib/systemd/system/ext-respondd.service:
  file.managed:
    - source: salt://respondd/files/ext-respondd.service
    - user: root
    - group: root
    - mode: 644

ext-respondd service:
  service.running:
    - enable: True
    - require:
      - file: /lib/systemd/system/ext-respondd.service
