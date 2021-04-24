{% for no, file in [10, "basic-settings"], [20, "basic-protocols"], [25, "igp"] %}
/etc/bird/bird.d/{{ '%02d' % (no) }}-{{ file }}.conf:
  file.managed:
    - source:
      - salt://routing/files/mgmt/bird.d/{{ '%02d' % (no) }}-{{ file }}.conf
      - salt://routing/files/mgmt/bird.d/{{ file }}.conf

    - template: jinja
    - user: bird
    - group: bird
    - mode: '0644'
    - require:
      - file: /etc/bird/bird.d/
{% endfor %}