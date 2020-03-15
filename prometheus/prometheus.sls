{%- from 'prometheus/map.jinja' import prometheus with context -%}
prometheus:
  user.present

prometheus tarball:
  archive.extracted:
    - source: https://github.com/prometheus/prometheus/releases/download/v{{ prometheus['release'] }}/prometheus-{{ prometheus['release'] }}.linux-amd64.tar.gz
    - source_hash: sha256={{ prometheus['release_hash'] }}
    - if_missing: /opt/prometheus-{{ prometheus['release'] }}.linux-amd64
    - name: /opt
    - user: root
    - group: root

/etc/prometheus:
  file.directory

/etc/prometheus/prometheus.yml:
  file.managed:
    - source: salt://prometheus/files/prometheus.yml.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja

/etc/default/prometheus:
  file.managed:
    - source: salt://prometheus/files/prometheus
    - user: root
    - group: root
    - mode: '0644'
    - watch_in:
      - service: prometheus.service

/etc/systemd/system/prometheus.service:
  file.managed:
    - source: salt://prometheus/files/prometheus.service.j2
    - template: jinja
    - watch_in:
      - service: prometheus.service

prometheus.service:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - archive: prometheus tarball
      - file: /etc/prometheus*
