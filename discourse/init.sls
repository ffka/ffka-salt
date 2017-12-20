{%- set dir = '/srv/www/forum/discourse' -%}

discourse:
  git.latest:
    - name: https://github.com/discourse/discourse_docker.git
    - target: {{ dir }}
    - unless: test -f {{ dir }}/containers/app.yml
    - require:
      - file: {{ dir }}
      - test: nginx_forum

{{ dir }}/containers/app.yml:
  file.managed:
    - source: salt://discourse/files/app.yml.j2
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - git: discourse