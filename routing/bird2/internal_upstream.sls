# replaces internal_upstream.sls (which was based on bird 1)

{% for name, peer in salt['pillar.get']('routing:internal_upstream', {}).items() %}
/etc/bird/bird.d/51-internal-upstream-{{ name }}.conf:
  file.managed:
    - source: salt://routing/files/bird2/bird.d/internal-upstream.conf
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

/etc/bird/bird.d/50-internal-upstream-filters.conf:
  file.managed:
    - source: salt://routing/files/bird2/bird.d/internal-upstream-filters.conf
    - user: bird
    - group: bird
    - mode: '0644'
    - template: jinja
    - watch_in:
      - service: bird.service
    - require:
      - pkg: bird2
      - file: /etc/bird/bird.d/
