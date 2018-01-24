/etc/netdata/python.d/fastd.conf:
  file.managed:
    - name: /etc/netdata/python.d/fastd.conf
    - source: salt://netdata/files/fastd.conf.j2
    - user: root
    - group: netdata
    - watch_in:
      - service: netdata.service

/etc/netdata/python.d/fastd.conf:
  file.managed:
    - name: /usr/libexec/netdata/python.d/fastd.chart.py
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