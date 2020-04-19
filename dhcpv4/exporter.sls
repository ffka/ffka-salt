kea-exporter:
  pip.installed:
    - bin_env: '/usr/bin/pip3'
    - require:
      - pkg: packages_base

/etc/default/prometheus-kea-exporter:
  file.managed:
    - contents: |
        ARGS="--port 9547 --interval 7.5 --address \"[::]\" /tmp/kea-dhcp4-ctrl.sock /tmp/kea-dhcp6-ctrl.sock"
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja

/etc/systemd/system/prometheus-kea-exporter.service:
  file.managed:
    - contents: |
        [Unit]
        Description=Prometheus kea Exporter
        After=network.target

        [Service]
        Type=simple
        EnvironmentFile=/etc/default/prometheus-kea-exporter
        ExecStart=/usr/local/bin/kea-exporter $ARGS

        [Install]
        WantedBy=multi-user.target
    - user: root
    - group: root
    - mode: '0644'

prometheus-kea-exporter.service:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - file: /etc/systemd/system/prometheus-kea-exporter.service
      - file: /etc/default/prometheus-kea-exporter
      - pip: kea-exporter

kea@prometheus.exporters:
  grains.list_present:
    - name: prometheus.exporters
    - value: kea
