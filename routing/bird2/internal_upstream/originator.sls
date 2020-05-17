{% for number, name in [[10, "basic-settings"], [20, "basic-protocols"], [21, "static-routes"]] %}
/etc/bird/bird.d/{{ number }}-{{ name }}-upstream-originator.conf:
  file.managed:
    - source:
      - salt://routing/files/bird2/internal_upstream/{{ name }}.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: '0644'
    - watch_in:
      - service: bird.service
    - require:
      - pkg: bird2
      - file: /etc/bird/bird.d/
{% endfor %}
