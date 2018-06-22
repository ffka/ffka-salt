influxdb:
  pkgrepo.managed:
    - humanname: influxdb
    - name: deb https://repos.influxdata.com/debian stretch stable
    - dist: stretch
    - file: /etc/apt/sources.list.d/influxdb.list
    - gpgcheck: 1
    - key_url: https://repos.influxdata.com/influxdb.key
  pkg.installed: []