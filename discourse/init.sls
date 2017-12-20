{%- set dir = '/srv/www/forum' -%}

discourse:
  file.directory:
    - name: {{ dir }}
  git.latest:
    - name: https://github.com/discourse/discourse_docker.git
    - target: {{ dir }}
    - unless: test -f {{ dir }}/containers/app.yml
    - require:
      - file: {{ dir }}