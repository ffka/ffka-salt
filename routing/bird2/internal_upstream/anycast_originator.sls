{% for number, name in [[20, "basic-protocols"]] %}
/etc/bird/bird.d/{{ number }}-{{ name }}-anycast-originator.conf:
  file.managed:
    - source:
      - salt://routing/files/bird2/internal_upstream/{{ name }}-anycast.conf
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
