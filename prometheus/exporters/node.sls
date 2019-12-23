{% if salt['grains.get']('oscodename') == 'stretch' %}
include:
  - common.backport_repo

/etc/apt/preferences.d/prometheus-node-exporter:
  file.managed:
    - contents: |
        Package: prometheus-node-exporter
        Pin: release n=stretch-backports
        Pin-Priority: 800
    - template: jinja
    - require:
      - pkgrepo: debian_backports

prometheus-node-exporter:
  pkg.latest:
    - fromrepo: stretch-backports
    - require:
      - file: /etc/apt/preferences.d/prometheus-node-exporter
{% else %}
/etc/apt/preferences.d/prometheus-node-exporter:
  file.absent

prometheus-node-exporter:
  pkg.latest:
    - require:
      - file: /etc/apt/preferences.d/prometheus-node-exporter
{% endif %}

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

node@prometheus.exporters:
  grains.list_present:
    - name: prometheus.exporters
    - value: node
