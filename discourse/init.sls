{%- set dir = '/srv/www/forum/discourse' -%}

{{ dir }}:
  file.directory:
    - require:
      - test: nginx_forum

# watch this repository and initiate a rebuild if it changes
discourse:
  git.latest:
    - name: https://github.com/discourse/discourse.git
    - target: /usr/src/discourse
    - rev: {{ pillar.get('discourse:version', 'latest-release') }}

discourse_docker:
  git.latest:
    - name: https://github.com/discourse/discourse_docker.git
    - force_reset: True
    - target: {{ dir }}
    - unless: test -f {{ dir }}/containers/app.yml
    - require:
      - file: {{ dir }}


{{ dir }}/containers/app.yml:
  file.managed:
    - source: salt://discourse/files/app.yml.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - require:
      - git: discourse_docker
    - context:
        dir: {{ dir }}


discourse-rebuild:
  cmd.run:
    - name: ./launcher rebuild app
    - cwd: {{ dir }}
    - onchanges:
      - file: {{ dir }}/containers/app.yml
      - git: discourse
    - require:
      - file: {{ dir }}/containers/app.yml


/etc/systemd/system/discourse.service:
  file.managed:
    - source: salt://discourse/files/discourse.service.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - require:
      - cmd: discourse-rebuild
    - context:
        dir: {{ dir }}

discourse.service:
  service.running:
    - enable: True
    - restart: True
    - name: discourse
    - require:
      - file: /etc/systemd/system/discourse.service
      - file: {{ dir }}/containers/app.yml
    - watch:
      - cmd: discourse-rebuild
      - file: /etc/systemd/system/discourse.service
