{%- set dir = '/srv/www/forum/discourse' -%}

{{ dir }}:
  file.directory:
    - require:
      - test: nginx_forum

discourse:
  git.latest:
    - name: https://github.com/discourse/discourse_docker.git
    - target: {{ dir }}
    - unless: test -f {{ dir }}/containers/app.yml
    - require:
      - file: {{ dir }}

{{ dir }}/containers/app.yml:
  file.managed:
    - source: salt://discourse/files/app.yml.j2
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - git: discourse