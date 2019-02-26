# Connectivity between gwbats and backbone routers

{% for bird in ['bird','bird6'] %}
/etc/bird/{{ bird }}.d/51-internal-upstreams.conf:
  file.managed:
    - source: salt://routing/files/{{ bird }}.d/gwbat/internal-upstreams.conf
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