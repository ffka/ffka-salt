repos.influxdata.com:
  pkgrepo.managed:
    - humanname: influxdb
    - name: deb https://repos.influxdata.com/debian stretch stable
    - dist: stretch
    - file: /etc/apt/sources.list.d/influxdb.list
    - gpgcheck: 1
    - key_url: https://repos.influxdata.com/influxdb.key

influxdb:
  pkg.installed:
    - require:
      - pkgrepo: repos.influxdata.com

/etc/influxdb/influxdb.conf:
  file.managed:
    - source: salt://influxdb/files/influxdb.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: influxdb

influxdb.service:
  service.running:
    - enable: True
    - restart: True
    - require:
      - pkg: influxdb
    - watch:
      - file: /etc/influxdb/influxdb.conf