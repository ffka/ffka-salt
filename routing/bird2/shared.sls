{% for file in ["20-basic-protocols"] %}
/etc/bird/bird.d/{{ file }}.conf:
  file.managed:
    - source:
      - salt://routing/files/bird2/bird.d/{{ file }}.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: '0644'
    - require:
      - file: /etc/bird/bird.d/
{% endfor %}
