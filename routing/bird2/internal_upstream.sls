# replaces internal_upstream.sls (which was based on bird 1)

{% for name, peer in salt['pillar.get']('routing:internal_upstream', {}).items() %}
/etc/bird/bird.d/51-internal-upstream-{{ name }}.conf:
  file.managed:
    - source: salt://routing/files/bird2/bird.d/51-internal-upstream.conf
    - user: bird
    - group: bird
    - mode: '0644'
    - template: jinja
    - context:
        name: {{ name }}
        peer: {{ peer }}
    - watch_in:
      - service: bird.service
    - require:
      - pkg: bird2
      - file: /etc/bird/bird.d/
{% endfor %}

{% for file in ["50-internal-upstreams-basic", "50-internal-upstream-filters"] %}
/etc/bird/bird.d/{{ file }}.conf:
  file.managed:
    - source:
      - salt://routing/files/bird2/bird.d/{{ file }}.conf
      - salt://routing/files/common/{{ file }}.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: '0644'
    - require:
      - file: /etc/bird/bird.d/
{% endfor %}
