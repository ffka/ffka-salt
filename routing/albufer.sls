{% for bird in ['bird','bird6'] %}
/etc/bird/{{ bird }}.d/40-albufer.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: 644
    - template: jinja
    - source: salt://routing/files/{{ bird }}.d/albufer.conf
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}
        dhcp: {{ pillar['dhcp'] }}
    - watch_in:
      - service: {{ bird }}
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/{{ bird }}.d
{% endfor %}

/etc/bird/bird6.d/42-radv.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: 644
    - template: jinja
    - source: salt://routing/files/bird6.d/radv.conf
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}
    - watch_in:
      - service: bird6
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/bird6.d
