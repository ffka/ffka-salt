{% if salt['grains.get']('oscodename') == 'stretch' %}
/etc/apt/preferences.d/prometheus-node-exporter:
  file.managed:
    - contents: |
        Package: prometheus-node-exporter
        Pin: release n=backports
        Pin-Priority: 800
    - template: jinja

prometheus-node-exporter:
  pkg.latest
    - fromrepo: debian_backports
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

prometheus.exporters:
  grains.list_present:
    - value: node
