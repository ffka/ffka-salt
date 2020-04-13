{%- set deploy_dir = salt['pillar.get']('meshviewer:webroot', None) -%}

{% if deploy_dir %}
meshviewer:
  archive.extracted:
    - name: {{ deploy_dir }}
    - source: https://github.com/freifunk-ffm/meshviewer/releases/download/v12.0.1/meshviewer-build.zip
    - user: www-data
    - group: www-data
    - source_hash: sha256=4e38bd9b6401cb2f5bf772352d60e66a390175b5bfb7c4291fec1d46ac3646b7
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

