bird:
  pkg.installed

{% for bird in ['bird','bird6'] %}
/etc/bird/{{ bird }}.d:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - require:
      - pkg: bird

/etc/bird/{{ bird }}.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: bird
    - contents: |
        include "/etc/bird/{{ bird }}.d/*.conf";

/etc/bird/{{ bird }}.d/00-common.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://routing/files/common.conf
    - require:
      - pkg: bird
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
