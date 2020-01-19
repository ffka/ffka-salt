
grafana:
  pkgrepo.managed:
    - humanname: grafana
    - name: deb https://packages.grafana.com/oss/deb stable main
    - key_url: https://packages.grafana.com/gpg.key
    - file: /etc/apt/sources.list.d/grafana.list
  pkg.installed: []

/etc/default/grafana-server:
  file.managed:
    - source: salt://grafana/files/grafana-server-default
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: grafana

/etc/grafana/grafana.ini:
  file.managed:
    - source: salt://grafana/files/grafana.ini.j2
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
      instance: {{ salt['pillar.get']('grafana:instances:default') }}
    - require:
      - pkg: grafana

grafana-server:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - file: /etc/default/grafana-server
      - file: /etc/grafana/grafana.ini
    - require:
      - pkg: grafana
