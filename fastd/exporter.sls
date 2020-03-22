{%- set gopath = salt['pillar.get']('golang:gopath', '/usr/local/go') %}
{%- set gopkg = 'git.darmstadt.ccc.de/ffda/fastd-exporter' %}

include:
  - golang

https://{{ gopkg }}:
  git.latest:
    - target: {{ gopath }}/src/{{ gopkg }}
    - require:
      - pkg: golang

go get {{ gopkg }}:
  cmd.run:
    - cwd: {{ gopath }}/src/{{ gopkg }}
    - name: go install -i
    - env:
        GOPATH: {{ gopath }}
        GO111MODULE: "on"
        GOCACHE: /root/.cache/go-build
    - require:
      - pkg: golang
    - onchanges:
      - git: https://{{ gopkg }}

/etc/default/prometheus-fastd-exporter:
  file.managed:
    - source: salt://fastd/files/prometheus-fastd-exporter
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja

/etc/systemd/system/prometheus-fastd-exporter.service:
  file.managed:
    - source: salt://fastd/files/prometheus-fastd-exporter.service
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - context:
        gopath: {{ gopath }}
    - require:
      - file: /etc/default/prometheus-fastd-exporter

prometheus-fastd-exporter.service:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - file: /etc/systemd/system/prometheus-fastd-exporter.service
      - cmd: go get {{ gopkg }}

fastd@prometheus.exporters:
  grains.list_present:
    - name: prometheus.exporters
    - value: fastd
