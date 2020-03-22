bird:
  pkg.installed: []
  user.present: []

{% for bird, af in [['bird', 'ipv4'], ['bird6', 'ipv6']] %}
/etc/bird/{{ bird }}.d:
  file.directory:
    - user: bird
    - group: bird
    - dir_mode: '0755'
    - require:
      - pkg: bird
      - user: bird

/etc/bird/{{ bird }}.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: '0644'
    - require:
      - pkg: bird
      - user: bird
    - contents: |
        include "/etc/bird/{{ bird }}.d/*.conf";

/etc/bird/{{ bird }}.d/00-common.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: '0644'
    - template: jinja
    - source: salt://routing/files/common.conf
    - context:
      af: {{ af }}
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/{{ bird }}.d

/etc/bird/{{ bird }}.d/05-communities.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: '0644'
    - template: jinja
    - source: salt://routing/files/common/05-communities.conf
    - context:
      af: {{ af }}
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
