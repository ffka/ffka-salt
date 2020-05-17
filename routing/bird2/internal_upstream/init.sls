{% for name, peer in salt['pillar.get']('routing:internal_upstream', {}).items() %}
/etc/bird/bird.d/51-internal-upstream-{{ name }}.conf:
  file.managed:
    - source: salt://routing/files/bird2/internal_upstream/session.conf
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

{% for number, name in [[51, "basic"], [50, "filters"]] %}
/etc/bird/bird.d/{{ number }}-internal-upstream-{{ name }}.conf:
  file.managed:
    - source:
      - salt://routing/files/bird2/internal_upstream/{{ name }}.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: '0644'
    - require:
      - file: /etc/bird/bird.d/
{% endfor %}
