{%- for name, peer in salt['pillar.get']('routing:ebgp', {}).items() %}
/etc/bird2/bird.d/{{ peer['type'] }}s/{{ name }}.conf:
  file.managed:
    - source: salt://routing/files/bird2/session_templates/{{ peer['type'] }}.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
        name: {{ name }}
        peer: {{ peer | yaml }}
    - require:
      - file: /etc/bird2/bird.d/{{ peer['type'] }}s/
{% endfor %}

/etc/bird2/bird.d/41-basic-protocols-originated-prefixes.conf:
  file.managed:
    - source: salt://routing/files/bird2/bird.d/41-basic-protocols-originated-prefixes.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/bird2/bird.d/
