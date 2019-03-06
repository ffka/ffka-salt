{% for bird in ['bird','bird6'] %}
/etc/bird/{{ bird }}.d/50-internal-upstreams-basic.conf:
  file.managed:
    - contents: |
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

/etc/bird/{{ bird }}.d/20-basic-protocols.conf:
  file.managed:
    - source: salt://routing/files/{{ bird }}.d/cloud_router/basic-protocols.conf
    - template: jinja
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

/etc/bird/bird.d/21-static-routes.conf:
  file.managed:
    - source: salt://routing/files/bird.d/static-routes.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: 644
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/bird.d
    - watch_in:
      - service: bird

include: 
  - routing.internal_upstream
  - routing.radv
