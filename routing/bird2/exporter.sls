
prometheus-bird-exporter:
  pkg.installed

/etc/default/prometheus-bird-exporter:
  file.managed:
    - contents: |
        ARGS="-bird.socket /var/run/bird/bird.ctl \
              -bird.v2 \
              -format.new \
              -proto.bgp \
              -proto.direct \
              -proto.kernel \
              -proto.ospf \
              -proto.static"
    - user: root
    - group: root
    - mode: '0644'
    - require:
       - pkg: prometheus-bird-exporter

#/etc/systemd/system/prometheus-bird-exporter.service:
#  file.managed:
#    - source: salt://routing/files/bird2/prometheus-bird-exporter.service
#    - user: root
#    - group: root
#    - mode: '0644'
#    - template: jinja

prometheus-bird-exporter.service:
  service.running:
    - enable: True
    - require:
      - file: /etc/default/prometheus-bird-exporter
      - file: /etc/systemd/system/prometheus-bird-exporter.service

bird@prometheus.exporters:
  grains.list_present:
    - name: prometheus.exporters
    - value: bird
