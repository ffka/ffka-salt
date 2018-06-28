{%- set gopath = '/var/lib/yanic/go' %}
{% set ffka = salt['pillar.get']('ffka') -%}

include:
  - golang

yanic:
  user.present:
    - home: /var/lib/yanic
    - gid_from_name: True
  git.latest:
    - name: https://github.com/FreifunkBremen/yanic
    - target: {{ gopath }}/src/github.com/FreifunkBremen/yanic
    - rev: fed895312c13c7318618061889b402311ad93077
    - user: yanic
    - force_fetch: True
    - require:
      - user: yanic
  cmd.run:
    - cwd: {{ gopath }}/src/github.com/FreifunkBremen/yanic
    - name: go get -v -u github.com/FreifunkBremen/yanic
    - runas: yanic
    - env:
        GOPATH: {{ gopath }}
    - require:
      - pkg: golang
      - git: yanic
    - onchanges:
      - git: yanic

/var/log/yanic:
  file.directory:
    - user: yanic
    - group: adm
    - dir_mode: 2750
    - require:
      - user: yanic

/etc/yanic:
  file.directory:
    - user: root
    - group: yanic
    - dir_mode: 0755

/var/lib/yanic/state:
  file.directory:
    - user: yanic
    - group: yanic
    - dir_mode: 0755

/etc/systemd/system/yanic@.service:
  file.managed:
    - source: salt://yanic/files/yanic@.service
    - user: root
    - group: root
    - mode: 0644

/var/lib/yanic/meshviewer/{{ ffka.site_code }}:
  file.directory:
    - user: yanic
    - group: yanic
    - dir_mode: 0755
    - makedirs: True

/var/lib/yanic/nodelist/{{ ffka.site_code }}:
  file.directory:
    - user: yanic
    - group: yanic
    - dir_mode: 0755
    - makedirs: True

/etc/yanic/config-{{ ffka.site_code }}.toml:
  file.managed:
    - source: salt://yanic/files/config.toml.j2
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - context:
        ffka: {{ pillar['ffka'] }}

yanic@{{ ffka.site_code }}:
  service.running:
    - enable: True
    - require:
      - file: /var/lib/yanic/meshviewer/{{ ffka.site_code }}
      - file: /var/lib/yanic/nodelist/{{ ffka.site_code }}
      - file: /etc/systemd/system/yanic@.service
      - file: /var/log/yanic
      - file: /etc/yanic/config-{{ ffka.site_code }}.toml
    - watch:
      - file: /etc/systemd/system/yanic@.service
      - file: /etc/yanic/config-{{ ffka.site_code }}.toml
      - cmd: yanic
