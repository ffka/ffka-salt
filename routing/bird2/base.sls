{% for file in ["05-communities", "06-constants", "10-basic-settings", "30-policy-communities", "39-policy-internal-downstreams"] %}
/etc/bird/bird.d/{{ file }}.conf:
  file.managed:
    - source:
      - salt://routing/files/bird2/bird.d/{{ file }}.conf
      - salt://routing/files/common/{{ file }}.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: '0644'
    - require:
      - file: /etc/bird/bird.d/
{% endfor %}
