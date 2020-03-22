# Connectivity between gwbats and backbone routers

{% for bird in ['bird','bird6'] %}
/etc/bird/{{ bird }}.d/50-internal-upstreams-basic.conf:
  file.managed:
    - source: salt://routing/files/{{ bird }}.d/gwbat/internal-upstreams.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: '0644'
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/{{ bird }}.d
    - watch_in:
      - service: {{ bird }}
{% endfor %}

include:
  - routing.internal_upstream