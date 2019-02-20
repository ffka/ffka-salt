{%- set name = salt['pillar.get']('shortname') -%}
{%- set gw = salt['pillar.get']('backbone', {}).get(name) -%}

{%- for other_name, other_gw in salt['pillar.get']('backbone', {}).items() if other_name != name %}
/etc/bird2/bird.d/ibgp/{{ other_name }}.conf:
  file.managed:
    - source: salt://routing/files/bird2/ibgp.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
        name: {{ name }}
        gw: {{ gw | yaml }}
        other_name: {{ other_name }}
        other_gw: {{ other_gw | yaml }}
    - require:
      - file: /etc/bird2/bird.d/ibgp/
{% endfor %}
