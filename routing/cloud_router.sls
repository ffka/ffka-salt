{% for bird in ['bird','bird6'] %}
/etc/bird/{{ bird }}.d/50-internal-upstreams-basic.conf:
  file.managed:
    - content: |
        template bgp internal_upstream {
        };
    - user: bird
    - group: bird
    - mode: 644
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/{{ bird }}.d
    - watch_in:
      - service: {{ bird }}
{% endfor %}

include:
  - routing.internal_upstream