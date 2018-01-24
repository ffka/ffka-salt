/etc/netdata/python.d/fastd.conf:
  file.managed:
    - source: salt://netdata/files/fastd.conf.j2
    - template: jinja
    - user: root
    - group: netdata
    - watch_in:
      - service: netdata.service

/usr/libexec/netdata/python.d/fastd.chart.py:
  file.managed:
    - source: salt://netdata/files/fastd.chart.py
    - user: root
    - group: netdata
    - watch_in:
      - service: netdata.service

enable netdata fastd:
  file.accumulated:
    - filename: /etc/netdata/python.d.conf
    - text: 'fastd: yes'
    - require_in:
      - file: /etc/netdata/python.d.conf