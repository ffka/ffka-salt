{%- set gopath = '/var/lib/tflow2/go' %}

tflow2:
  user.present:
    - home: /var/lib/tflow2
    - gid_from_name: True
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
    - user: root
    - group: tflow2
    - dir_mode: 0755
    - require:
      - user: tflow2

/var/log/tflow2:
  file.directory:
    - user: tflow2
    - group: tflow2
    - dir_mode: 2750
    - require:
      - user: tflow2

/etc/tflow2/config.yml:
  file.managed:
    - source: salt://tflow2/files/config.yml.j2
    - user: root
    - group: tflow2
    - mode: 0644
    - template: jinja
    - require:
      - file: /etc/tflow2
