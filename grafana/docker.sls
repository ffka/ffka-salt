{% set grafana_vesion = '6.3.2' %}

grafana/grafana:{{ grafana_vesion }}:
  docker_image.present

grafana:
  user.present:
    - uid: 472

/var/lib/grafana:
  file.directory:
    - user: grafana
    - dir_mode: 755
    - require:
      - user: grafana

{% for name, instance in salt['pillar.get']('grafana:instances', {}).items() %}
/var/lib/grafana/{{ name }}:
  file.directory:
    - user: grafana
    - dir_mode: 755
    - require:
      - user: grafana
      - file: /var/lib/grafana

/var/lib/grafana/{{ name }}/data:
  file.directory:
    - user: grafana
    - dir_mode: 755
    - require:
      - user: grafana
      - file: /var/lib/grafana/{{ name }}

/var/lib/grafana/{{ name }}/grafana.ini:
  file.managed:
    - source: salt://grafana/files/grafana.ini.j2
    - user: grafana
    - mode: 644
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
{% endfor %}
