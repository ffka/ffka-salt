{% for bird in ['bird','bird6'] %}
/etc/bird/{{ bird }}.d/40-albufer.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://routing/files/{{ bird }}.d/albufer.conf
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}
        dhcp: {{ pillar['dhcp'] }}
    - watch_in:
      - service: {{ bird }}
    - require:
      - pkg: bird
      - file: /etc/bird/{{ bird }}.d
{% endfor %}

/etc/bird/{{ bird }}.d/42-radv.conf:
  file.managed:
    - source: salt://routing/files/{{ bird }}.d/radv.conf
    - template: jinja
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}
