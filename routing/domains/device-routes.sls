{% for bird in ['bird','bird6'] %}
/etc/bird/{{ bird }}.d/10-device-routes.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: 644
    - template: jinja
    - source: salt://routing/files/{{ bird }}.d/domains-device-routes.conf
    - watch_in:
      - service: {{ bird }}
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/{{ bird }}.d
{% endfor %}
