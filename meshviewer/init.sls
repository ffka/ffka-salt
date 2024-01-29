{%- set deploy_dir = salt['pillar.get']('meshviewer:webroot', None) -%}

{% if deploy_dir %}
meshviewer:
  archive.extracted:
    - name: {{ deploy_dir }}
    - source: https://github.com/freifunk/meshviewer/releases/download/v12.4.0/meshviewer-build.zip
    - user: www-data
    - group: www-data
    - source_hash: sha256=619b6c7244e543af34f8fe10654aba88f5d2a8c87701a60915e01874f2dea478
    - source_hash_update: true
    - keep_source: false
    - clean: true
    - enforce_toplevel: false
    - require_in:
      - file: meshviewer-config

meshviewer-config:
  file.managed:
    - name: {{ deploy_dir }}config.json
    - source: salt://meshviewer/files/config.json.j2
    - user: www-data
    - group: www-data
    - mode: '0644'
    - template: jinja
    - context:
      api_endpoint: {{ salt['pillar.get']('meshviewer:api_endpoint') }}
{% endif %}

