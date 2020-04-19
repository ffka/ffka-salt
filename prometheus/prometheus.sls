{%- from 'prometheus/map.jinja' import prometheus with context -%}
prometheus:
  user.present

prometheus-pillar:
  test.check_pillar:
    - dictionary:
      - prometheus

/root/.ssh/id_prometheus:
  cmd.run:
    - name: ssh-keygen -C 'root@{{ salt['pillar.get']('hostname') }}' -q -N '' -f /root/.ssh/id_prometheus
    - unless: test -f /root/.ssh/id_prometheus

prometheus.tar.gz:
  archive.extracted:
    - source: https://github.com/prometheus/prometheus/releases/download/v{{ prometheus['release'] }}/prometheus-{{ prometheus['release'] }}.linux-amd64.tar.gz
    - source_hash: sha256={{ prometheus['release_hash'] }}
    - if_missing: /opt/prometheus-{{ prometheus['release'] }}.linux-amd64
    - name: /opt
    - user: root
    - group: root

/etc/prometheus:
  file.directory:
    - user: root
    - group: root

/etc/prometheus/prometheus.yml:
  file.managed:
    - source: salt://prometheus/files/prometheus.yml
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - require:
      - prometheus-pillar

/etc/default/prometheus:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        ARGS="--config.file=/etc/prometheus/prometheus.yml {% if salt['pillar.get']('prometheus:external_hostname') %} --web.external-url={{ pillar['prometheus']['external_hostname'] }}/prometheus/ --web.listen-address=\"[::1]:9090\"{% else %} --web.listen-address=\"[::]:9090\"{% endif %} --storage.tsdb.retention.time={{ salt['pillar.get']('prometheus:retention:time') }} --storage.tsdb.retention.size={{ salt['pillar.get']('prometheus:retention:size') }} --log.level=info --log.format=logfmt"
    - require:
      - prometheus-pillar

/etc/systemd/system/prometheus.service:
  file.managed:
    - source: salt://prometheus/files/prometheus.service
    - template: jinja
    - context:
        prometheus: {{ prometheus | yaml }}
    - require:
      - archive: prometheus.tar.gz

/var/lib/prometheus:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'

{{ salt['pillar.get']('prometheus:rules_repo') }}:
  git.latest:
    - user: root
    - identity: /root/.ssh/id_prometheus
    - target: /etc/prometheus/rules
    - force_fetch: True
    - force_reset: True
    - require:
      - cmd: /root/.ssh/id_prometheus
      - file: /etc/prometheus

prometheus.service:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - user: prometheus
      - archive: prometheus.tar.gz
      - file: /etc/systemd/system/prometheus.service
      - file: /etc/default/prometheus
      - file: /etc/prometheus*
      - file: /var/lib/prometheus
      - git: {{ salt['pillar.get']('prometheus:rules_repo') }}
