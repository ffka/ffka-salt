# This state will be deleted once core0 is mighrated to the new backbone
{% for bird in ['bird','bird6'] %}
/etc/bird/{{ bird }}.d/50-cloud-gateway.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: 644
    - template: jinja
    - source: salt://routing/files/{{ bird }}.d/cloud-gateway.conf
    - watch_in:
      - service: {{ bird }}
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/{{ bird }}.d
{% endfor %}
