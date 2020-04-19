{%- from 'prometheus/map.jinja' import alertmanager with context -%}

alertmanager.tar.gz:
  archive.extracted:
    - source: https://github.com/prometheus/alertmanager/releases/download/v{{ alertmanager['release'] }}/alertmanager-{{ alertmanager['release'] }}.linux-amd64.tar.gz
    - source_hash: sha256={{ alertmanager['release_hash'] }}
    - if_missing: /opt/alertmanager-{{ alertmanager['release'] }}.linux-amd64
    - name: /opt
    - user: root
    - group: root

/etc/prometheus/alertmanager:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'
    - require:
      - file: /etc/prometheus

/etc/prometheus/alertmanager.yml:
  file.managed:
    - source: salt://prometheus/files/alertmanager.yml
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja

/etc/default/prometheus-alertmanager:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        ARGS="--config.file=/etc/prometheus/alertmanager.yml {% if salt['pillar.get']('prometheus:external_hostname') %} --web.external-url={{ pillar['prometheus']['external_hostname'] }}/alertmanager/ --web.listen-address=\"[::1]:9093\"{% else %} --web.listen-address=\"[::]:9093\"{% endif %} --storage.path=/var/lib/prometheus/alertmanager/"

/etc/systemd/system/prometheus-alertmanager.service:
  file.managed:
    - source: salt://prometheus/files/prometheus-alertmanager.service
    - template: jinja
    - context:
        alertmanager: {{ alertmanager | yaml }}
    - require:
      - archive: alertmanager.tar.gz

/var/lib/prometheus/alertmanager:
  file.directory:
    - user: prometheus
    - group: prometheus
    - mode: '0755'
    - require:
      - user: prometheus
      - file: /var/lib/prometheus

{{ salt['pillar.get']('prometheus:alert_templates_repo') }}:
  git.latest:
    - user: root
    - identity: /root/.ssh/id_prometheus
    - target: /etc/prometheus/alertmanager/templates
    - require:
      - cmd: /root/.ssh/id_prometheus
      - file: /etc/prometheus/alertmanager

prometheus-alertmanager.service:
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: /var/lib/prometheus/alertmanager
      - user: prometheus
    - watch:
      - archive: alertmanager.tar.gz
      - file: /etc/systemd/system/prometheus-alertmanager.service
      - file: /etc/default/prometheus-alertmanager
      - file: /etc/prometheus*
      - git: {{ salt['pillar.get']('prometheus:alert_templates_repo') }}
