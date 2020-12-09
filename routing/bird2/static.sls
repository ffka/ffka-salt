{% for number, file in [[21, "static-routes"]] %}
/etc/bird/bird.d/{{ number }}-{{ file }}.conf:
  file.managed:
    - source:
      - salt://routing/files/bird2/bird.d/{{ number }}-{{ file }}.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: 644
    - require:
      - pkg: bird2
      - file: /etc/bird/bird.d/
    - watch_in:
      - service: bird.service
{% endfor %}
