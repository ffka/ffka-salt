{% for bird in ['bird','bird6'] %}

/etc/bird/{{ bird }}.d/00-common.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: 644
    - template: jinja
    - source: salt://routing/files/{{ bird }}.d/backbone/bird6.conf
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/{{ bird }}.d

{% endfor %}
