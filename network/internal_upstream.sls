/etc/ferm/conf.d/internal-upstreams-clamp-mss.conf:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - source: salt://ferm/files/clamp-mss.conf.j2
    - template: jinja
    - require:
      - file: /etc/ferm/conf.d
    - watch_in:
      - service: ferm.service
    - context:
      {%- for af in ['ipv4', 'ipv6'] %}
      {{ af }}:
      {%- for if in salt['pillar.get']('routing:internal_upstream', {}).values() | map(attribute='interface') | unique %}
        {{ if }}: {{ salt['pillar.get']('network:internal_upstream:mss:' ~ af , 1280) }}
      {%- endfor %}
      {%- endfor %}
