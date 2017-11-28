{%- from 'prometheus/map.jinja' import prometheus with context -%}
prometheus:
  user.present

prometheus tarball:
  archive.extracted:
    - source: https://github.com/prometheus/prometheus/releases/download/v{{ prometheus['release'] }}/prometheus-{{ prometheus['release'] }}.linux-amd64.tar.gz
    - source_hash: sha256={{ prometheus['release_hash'] }}
    - if_missing: /opt/prometheus-{{ prometheus['release'] }}.linux-amd64
    - name: /opt
    - user: prometheus
    - group: prometheus
    - watch_in:
      - service: prometheus.service

/etc/prometheus:
  file.directory

/etc/prometheus/prometheus.yml:
  file.managed:
    - source: salt://prometheus/files/prometheus.yml.j2
    - user: prometheus
    - group: prometheus
    - mode: 644
    - template: jinja

/etc/default/prometheus:
  file.managed:
    - source: salt://prometheus/files/prometheus
    - user: prometheus
    - group: prometheus
    - mode: 644

/etc/systemd/system/prometheus.service:
  file.managed:
    - source: salt://prometheus/files/prometheus.service.j2
    - template: jinja

prometheus.service:
  service.running:
    - enable: True
    - watch:
      - file: /etc/prometheus/*
      - file: /etc/default/prometheus
      - file: /etc/systemd/system/prometheus.service
    - require:
      - archive: prometheus tarball
      - file: /etc/systemd/system/prometheus.service
      - file: /etc/prometheus/*
      - file: /etc/default/prometheus
