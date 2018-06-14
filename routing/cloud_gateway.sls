{% for bird in ['bird','bird6'] %}
/etc/bird/{{ bird }}.d/50-cloud-gateway.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://routing/files/{{ bird }}.d/cloud-gateway.conf
    - watch_in:
      - service: {{ bird }}
    - require:
      - pkg: bird
      - file: /etc/bird/{{ bird }}.d
{% endfor %}
