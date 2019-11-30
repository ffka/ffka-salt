{%- set name = salt['pillar.get']('shortname') -%}
{%- set gw = salt['pillar.get']('backbone', {}).get(name) -%}

{%- for other_name, other_gw in salt['pillar.get']('backbone', {}).items() if other_name != name %}
/etc/bird/bird.d/ibgp/{{ other_name }}.conf:
  file.managed:
    - source: salt://routing/files/bird2/session_templates/ibgp.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: 644
    - context:
        name: {{ name }}
        gw: {{ gw | yaml }}
        other_name: {{ other_name }}
        other_gw: {{ other_gw | yaml }}
    - require:
      - file: /etc/bird/bird.d/ibgp/
{% endfor %}

{%- for name, peer in salt['pillar.get']('routing:internal_downstream', {}).items() %}
/etc/bird/bird.d/internal_downstreams/{{ name }}.conf:
  file.managed:
    - source: salt://routing/files/bird2/session_templates/internal_downstream.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: 644
    - context:
        name: {{ name }}
        peer: {{ peer }}
    - require:
      - file: /etc/bird/bird.d/internal_downstreams/
{% endfor %}

/etc/bird/bird.d/41-basic-protocols-internal-downstreams.conf:
  file.managed:
    - source: salt://routing/files/bird2/bird.d/41-basic-protocols-internal-downstreams.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: 644
    - require:
      - file: /etc/bird/bird.d/
