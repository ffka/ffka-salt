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
    - require:
      - pkg: bird
      - user: bird
    - contents: |
        include "/etc/bird/{{ bird }}.d/*.conf";

/etc/bird/{{ bird }}.d/00-common.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: 644
    - template: jinja
    - source: salt://routing/files/common.conf
    - context:
        network: {{ pillar['network'] }}
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
