{%- for name, peer in salt['pillar.get']('routing:ebgp', {}).items() %}
/etc/bird2/bird.d/{{ peer['type'] }}s/{{ name }}.conf:
  file.managed:
    - source: salt://routing/files/bird2/{{ peer['type'] }}.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - context:
        name: {{ name }}
        peer: {{ peer | yaml }}
    - require:
      - file: /etc/bird2/bird.d/{{ peer['type'] }}s/
{% endfor %}
