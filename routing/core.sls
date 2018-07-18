{% for bird in ['bird','bird6'] %}
/etc/bird/bird6.d/30-core.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: 644
    - template: jinja
    - source: salt://routing/files/{{ bird }}.d/core.conf
    - watch_in:
      - service: {{ bird }}
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/{{ bird }}.d
{% endfor %}
