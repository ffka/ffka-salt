bird:
  pkg.installed: []
  user.present: []

{% for bird in ['bird','bird6'] %}
/etc/bird/{{ bird }}.d:
  file.directory:
    - user: bird
    - group: bird
    - dir_mode: 755
    - require:
      - pkg: bird
      - user: bird

/etc/bird/{{ bird }}.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: 644
    - template: jinja
    - source: salt://routing/files/{{ bird }}.d/backbone/{{ bird }}.conf
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/{{ bird }}.d

service {{ bird }}:
  service.running:
    - name: {{ bird }}
    - enable: true
    - reload: true
    - require:
      - pkg: bird
    - watch:
      - /etc/bird/{{ bird }}.conf
      - /etc/bird/{{ bird }}.d/*.conf
{% endfor %}

/etc/bird/bird6.d/ospf6.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: 644
    - template: jinja
    - source: salt://routing/bird6.d/backbone/ospf6.conf
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/bird6.d
