{%- set gopath = '/var/lib/tflow2/go' %}

include:
  - golang

tflow2:
  user.present:
    - home: /var/lib/tflow2
  git.latest:
    - name: https://github.com/taktv6/tflow2.git
    - target: {{ gopath }}/src/github.com/taktv6/tflow2
    - rev: master
    - user: tflow2
    - force_fetch: True
    - require:
      - user: tflow2
  cmd.run:
    - cwd: {{ gopath }}/src/github.com/taktv6/tflow2
    - name: go get -v -u github.com/taktv6/tflow2
    - runas: tflow2
    - env:
        GOPATH: {{ gopath }}
    - require:
      - pkg: golang
      - git: tflow2
    - onchanges:
      - git: tflow2

/etc/tflow2:
  file.directory:
    - user: tflow2
    - group: root
    - dir_mode: 0755
    - require:
      - user: tflow2

/var/tflow2/data:
  file.directory:
    - user: tflow2
    - group: root
    - dir_mode: 0755
    - makedirs: True
    - require:
      - user: tflow2

/var/log/tflow2:
  file.directory:
    - user: tflow2
    - group: root
    - dir_mode: 2750
    - require:
      - user: tflow2

/etc/tflow2/config.yml:
  file.managed:
    - source: salt://tflow2/files/config.yml.j2
    - user: tflow2
    - group: root
    - mode: 0644
    - template: jinja
    - require:
      - file: /etc/tflow2

/etc/systemd/system/tflow2.service:
  file.managed:
    - source: salt://tflow2/files/tflow2.service.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
        gopath: {{ gopath }}

tflow2.service:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - cmd: tflow2
      - file: /etc/tflow2/config.yml
      - file: /etc/systemd/system/tflow2.service
    - require:
      - file: /var/tflow2/data
      - file: /var/log/tflow2

{% for bird in ['bird','bird6'] %}
/etc/bird/{{ bird }}.d/90-tflow2-common.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: 644
    - template: jinja
    - source: salt://tflow2/files/bird_common.conf.j2
    - require:
      - pkg: bird
      - file: /etc/bird/{{ bird }}.d

/etc/bird/{{ bird }}.d/91-tflow2.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: 644
    - template: jinja
    - source: salt://tflow2/files/{{ bird }}_client.conf.j2
    - require:
      - pkg: bird
      - file: /etc/bird/{{ bird }}.d
{% endfor %}