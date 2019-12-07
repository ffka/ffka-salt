include:
  - common.debian_unstable

/etc/apt/preferences.d/prometheus-bird-exporter:
  file.managed:
    - contents: |
        Package: prometheus-bird-exporter
        Pin: release n=unstable
        Pin-Priority: 800
    - template: jinja
    - require:
      - pkgrepo: unstable

prometheus-bird-exporter:
  pkg.latest:
    - fromrepo: unstable
    - require:
      - file: /etc/apt/preferences.d/prometheus-bird-exporter

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
    - mode: 644
    - require:
       - pkg: prometheus-bird-exporter

prometheus-bird-exporter.service:
  service.running:
    - enable: True
    - require:
      - pkg: prometheus-bird-exporter
      - file: /etc/default/prometheus-bird-exporter

prometheus.exporters:
  grains.list_present:
    - value: bird
