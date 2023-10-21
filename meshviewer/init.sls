{%- set deploy_dir = salt['pillar.get']('meshviewer:webroot', None) -%}

{% if deploy_dir %}
meshviewer:
  archive.extracted:
    - name: {{ deploy_dir }}
    - source: https://github.com/freifunk/meshviewer/releases/download/v12.3.0/meshviewer-build.zip
    - user: www-data
    - group: www-data
    - source_hash: sha256=534c0ad7665139b42931c0f43d806d9e459fd231317a277292cd5261cacffa4c
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

