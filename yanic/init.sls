{%- set gopath = '/var/lib/yanic/go' %}

include:
  - golang

yanic:
  group.present:
    []
  user.present:
    - home: /var/lib/yanic
    - gid_from_name: True
  git.latest:
    - name: https://github.com/FreifunkBremen/yanic
    - target: {{ gopath }}/src/github.com/FreifunkBremen/yanic
    - rev: master
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
    - require:
      - user: yanic

/var/lib/yanic/state:
  file.directory:
    - user: yanic
    - group: yanic
    - dir_mode: 0755
    - require:
      - user: yanic

/etc/systemd/system/yanic@.service:
  file.managed:
    - source: salt://yanic/files/yanic@.service
    - user: root
    - group: root
    - mode: 0644
    - require:
      - user: yanic

{% for instance, settings in salt['pillar.get']('yanic:instances', {}).items() %}
/var/lib/yanic/meshviewer/{{ instance }}:
  file.directory:
    - user: yanic
    - group: yanic
    - dir_mode: 0755
    - makedirs: True
    - require:
      - user: yanic
    - require_in:
      - service: yanic@{{ instance }}

/var/lib/yanic/nodelist/{{ instance }}:
  file.directory:
    - user: yanic
    - group: yanic
    - dir_mode: 0755
    - makedirs: True
    - require:
      - user: yanic
    - require_in:
      - service: yanic@{{ instance }}

/etc/yanic/config-{{ instance }}.toml:
  file.managed:
    - source: salt://yanic/files/{{ settings['type'] }}.toml.j2
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - context:
        instance: {{ instance }}
        settings: {{ settings | yaml }}
    - require:
      - file: /etc/yanic
    - watch_in:
      - service: yanic@{{ instance }}

yanic@{{ instance }}:
  service.running:
    - enable: True
    - require:
      - file: /var/log/yanic
    - watch:
      - file: /etc/systemd/system/yanic@.service
      - cmd: yanic
{% endfor %}
