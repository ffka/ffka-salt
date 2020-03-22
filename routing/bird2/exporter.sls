{%- set gopath = '/var/lib/bird_exporter/go' %}
{%- set bird_export_version = "1.2.4" %}

include:
  - golang

/etc/apt/preferences.d/prometheus-bird-exporter:
  file.absent

prometheus-bird-exporter:
  pkg.purged

https://github.com/czerwonk/bird_exporter.git:
  git.latest:
    - target: {{ gopath }}/src/github.com/czerwonk/bird_exporter
    - rev: {{ bird_export_version }}
    - force_fetch: True

go get czerwonk/bird_exporter:
  cmd.run:
    - cwd: {{ gopath }}/src/github.com/czerwonk/bird_exporter
    - name: go install -i
    - env:
        GOPATH: {{ gopath }}
        GO111MODULE: "on"
        GOCACHE: /root/.cache/go-build
    - require:
      - pkg: golang
    - onchanges:
      - git: https://github.com/czerwonk/bird_exporter.git

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

/etc/systemd/system/prometheus-bird-exporter.service:
  file.managed:
    - source: salt://routing/files/bird2/prometheus-bird-exporter.service
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - context:
        gopath: {{ gopath }}

prometheus-bird-exporter.service:
  service.running:
    - enable: True
    - require:
      - cmd: go get czerwonk/bird_exporter
      - file: /etc/default/prometheus-bird-exporter
      - file: /etc/systemd/system/prometheus-bird-exporter.service

bird@prometheus.exporters:
  grains.list_present:
    - name: prometheus.exporters
    - value: bird

include:
  - golang