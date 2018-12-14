{% for bird in ['bird','bird6'] %}
/etc/bird/{{ bird }}.d/60-core-bat.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: 644
    - template: jinja
    - source: salt://routing/files/{{ bird }}.d/core-bat.conf
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}
    - watch_in:
      - service: {{ bird }}
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/{{ bird }}.d
{% endfor %}
