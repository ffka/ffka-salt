
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

prometheus-bird-exporter.service:
  service.running:
    - enable: True
    - require:
      - file: /etc/default/prometheus-bird-exporter
    

bird@prometheus.exporters:
  grains.list_present:
    - name: prometheus.exporters
    - value: bird
