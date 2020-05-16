{% for file in ["20-basic-protocols-upstream-originator", "06-constants-upstream-originator"] %}
/etc/bird/bird.d/{{ file }}.conf:
  file.managed:
    - source:
      - salt://routing/files/bird2/bird.d/{{ file }}.conf
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
