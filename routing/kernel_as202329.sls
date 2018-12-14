{% for bird in ['bird','bird6'] %}
/etc/bird/{{ bird }}.d/02-kernel-as202329.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: 644
    - template: jinja
    - source: salt://routing/files/{{ bird }}.d/gwbat/kernel-as202329.conf
    - watch_in:
      - service: {{ bird }}
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/{{ bird }}.d
{% endfor %}
