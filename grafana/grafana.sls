grafana_base:
  pkg.installed:
    - pkgs:
     - apt-transport-https

grafana:
  pkgrepo.managed:
    - humanname: grafana
    - name: deb https://packagecloud.io/grafana/stable/debian/ stretch main
    - key_url: https://packagecloud.io/gpg.key
    - file: /etc/apt/sources.list.d/grafana.list
  pkg.installed: []

grafana-server:
  service.running:
    - enable: True
    - watch:
      - file: /etc/default/grafana-server
      - file: /etc/grafana/grafana.ini
    - require:
      - pkg: grafana

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
    - source: salt://grafana/files/grafana.ini
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: grafana
