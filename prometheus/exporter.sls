prometheus-node-exporter:
  pkg.latest

/etc/default/prometheus-node-exporter:
  file.managed:
    - source: salt://prometheus/files/prometheus-node-exporter
    - user: root
    - group: root
    - mode: 644
    - require:
       - pkg: prometheus-node-exporter

prometheus-node-exporter.service:
  service.running:
    - enable: True
    - require:
      - pkg: prometheus-node-exporter
      - file: /etc/default/prometheus-node-exporter
