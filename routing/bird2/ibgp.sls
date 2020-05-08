{%- set name = salt['pillar.get']('shortname') -%}
{%- set gw = salt['pillar.get']('backbone', {}).get(name) -%}

{%- for other_name, other_gw in salt['pillar.get']('backbone', {}).items() if other_name != name %}
/etc/bird/bird.d/ibgp/{{ other_name }}.conf:
  file.managed:
    - source: salt://routing/files/bird2/session_templates/ibgp.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: '0644'
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
    - mode: '0644'
    - context:
        name: {{ name }}
        peer: {{ peer }}
    - require:
      - file: /etc/bird/bird.d/internal_downstreams/
{% endfor %}

{% for file in ["25-igp", "31-policy-ibgp-in-basic", "39-policy-ibgp", "40-ibgp-base", "40-internal-downstream-base", "41-basic-protocols-internal-downstreams", "45-ibgp-sessions"] %}
/etc/bird/bird.d/{{ file }}.conf:
  file.managed:
    - source:
      - salt://routing/files/bird2/bird.d/{{ file }}.conf
      - salt://routing/files/common/{{ file }}.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: '0755'
    - require:
      - file: /etc/bird/bird.d/
{% endfor %}

{% for dir in ["ibgp", "internal_downstreams"] %}
/etc/bird/bird.d/{{ dir }}/:
  file.directory:
    - mode: '0755'
    - user: bird
    - group: bird
    - require:
      - file: /etc/bird/bird.d/
{% endfor %}
