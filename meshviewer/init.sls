{%- set deploy_dir = salt['pillar.get']('meshviewer:webroot', None) -%}

{% if deploy_dir %}
meshviewer:
  archive.extracted:
    - name: {{ deploy_dir }}
    - source: https://github.com/freifunk-ffm/meshviewer/releases/download/v12.1.0/meshviewer-build.zip
    - user: www-data
    - group: www-data
    - source_hash: sha256=31744309167ac97a5133e53082dc7579339480f2e439901c4ba63e103ace640c
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

