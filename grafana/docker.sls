{% set grafana_vesion = '10.0.3-ubuntu' %}

grafana/grafana:{{ grafana_vesion }}:
  docker_image.present

grafana:
  user.present:
    - uid: 472

/var/lib/grafana:
  file.directory:
    - user: grafana
    - dir_mode: '0755'
    - require:
      - user: grafana

{% for name, instance in salt['pillar.get']('grafana:instances', {}).items() %}
/var/lib/grafana/{{ name }}:
  file.directory:
    - user: grafana
    - dir_mode: '0755'
    - require:
      - user: grafana
      - file: /var/lib/grafana

/var/lib/grafana/{{ name }}/data:
  file.directory:
    - user: grafana
    - dir_mode: '0755'
    - require:
      - user: grafana
      - file: /var/lib/grafana/{{ name }}

/var/lib/grafana/{{ name }}/grafana.ini:
  file.managed:
    - source: salt://grafana/files/grafana.ini.j2
    - user: grafana
    - mode: '0644'
    - template: jinja
    - context:
      instance: {{ instance | yaml }}
    - require:
      - file: /var/lib/grafana/{{ name }}

grafana_{{ name }}:
  docker_container.running:
    - image: grafana/grafana:{{ grafana_vesion }}
    - environment:
      - GF_PATHS_CONFIG: /var/lib/grafana/grafana.ini
      - GF_PATHS_DATA: /var/lib/grafana/data
      - GF_RENDERING_SERVER_URL: http://172.17.0.4:8081/render
      {% if 'plugins' in instance %}
      - GF_INSTALL_PLUGINS: {{ instance.get('plugins', []) | join(',') }}
      {% endif %}
    - binds:
      - /var/lib/grafana/{{ name }}:/var/lib/grafana
    - port_bindings:
      - 127.0.0.1:{{ instance['port'] }}:3000
    - restart_policy: always
    - user: grafana
    - require:
      - file: /var/lib/grafana/{{ name }}/grafana.ini
      - docker_image: grafana/grafana:{{ grafana_vesion }}
      - user: grafana
grafana_{{ name }}_renderer:
  docker_container.running:
    - image: grafana/grafana-image-renderer:latest
    - environment:
      - ENABLE_METRICS: 'true'
    - port_bindings:
      - 127.0.0.1:8081:8081
    - binds:
      - /opt/grafana-image-renderer/default.json:/usr/src/app/config.json
{% endfor %}
