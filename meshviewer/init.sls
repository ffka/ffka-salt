{% set map_domain = "map.frickelfunk.net" %}
meshviewer:
  user.present

nodejs:
  pkgrepo.managed:
    - humanname: nodejs
    - name: deb https://deb.nodesource.com/node_8.x stretch main
    - key_url: salt://apt/files/keys/nodejs.gpg
    - file: /etc/apt/sources.list.d/nodejs.list
    - require_in:
      - pkg: nodejs
    - require:
      - pkg: apt-transport-https
      - pkg: python-apt
  pkg.latest:
    - pkgs:
      - nodejs

yarn:
  pkgrepo.managed:
    - humanname: yarn
    - name: deb https://dl.yarnpkg.com/debian/ stable main
    - key_url: salt://apt/files/keys/yarn.gpg
    - file: /etc/apt/sources.list.d/yarn.list
    - require_in:
      - pkg: yarn
    - require:
      - pkg: apt-transport-https
      - pkg: python-apt
  pkg.latest:
    - pkgs:
      - yarn


/home/meshviewer/meshviewer.git:
  git.latest:
    - name: https://github.com/ffrgb/meshviewer.git
    - target: /home/meshviewer/meshviewer.git
    - user: meshviewer
    - force_fetch: True
    - force_reset: True
    - require:
      - pkg: git
      - pkg: nodejs
      - user: meshviewer

meshviewer_remove_build:
  cmd.run:
    - onchanges:
      - git: /home/meshviewer/meshviewer.git
      - pkg: nodejs
    - watch:
      - git: /home/meshviewer/meshviewer.git
      - pkg: nodejs
    - cwd: /home/meshviewer/meshviewer.git
    - name: rm -rf build

meshviewer_yarn_install:
  cmd.run:
    - onchanges:
      - cmd: meshviewer_remove_build
    - require:
      - pkg: yarn
      - cmd: meshviewer_remove_build
    - cwd: /home/meshviewer/meshviewer.git
    - user: meshviewer
    - name: yarn && yarn add gulp-cli

meshviewer_install_config:
  file.managed:
    - name: /home/meshviewer/meshviewer.git/config.json
    - user: www-data
    - group: www-data
    - source: salt://meshviewer/files/config.json.j2
    - template: jinja
    - require:
      - git: /home/meshviewer/meshviewer.git
    - watch:
      - git: /home/meshviewer/meshviewer.git

meshviewer_gulp:
  cmd.run:
    - onchanges:
      - cmd: meshviewer_yarn_install
      - file: meshviewer_install_config

    - require:
       - cmd: meshviewer_yarn_install
       - git: /home/meshviewer/meshviewer.git

    - cwd: /home/meshviewer/meshviewer.git
    - user: meshviewer
    - name: ./node_modules/.bin/gulp

create_srv_www:
  file.directory:
    - user: www-data
    - group: www-data
    - name: /srv/www

meshviewer_empty_srv_www:
  file.absent:
    - name: /srv/www/{{ map_domain }}/htdocs
    - require:
       - file: /srv/www/{{ map_domain }}
       - cmd: meshviewer_gulp
    - watch:
       - cmd: meshviewer_gulp

meshviewer_create_srv_www:
  file.directory:
    - user: www-data
    - group: www-data
    - name: /srv/www/{{ map_domain }}/htdocs
    - require:
       - file: meshviewer_empty_srv_www
    - watch:
       - file: meshviewer_empty_srv_www

meshviewer_copy_to_srv_www:
  cmd.run:
    - name: cp -ar /home/meshviewer/meshviewer.git/build/* /srv/www/{{ map_domain }}/htdocs/. && chown www-data:www-data -R /srv/www/{{ map_domain }}/htdocs/
    - require:
       - file: meshviewer_create_srv_www
    - onchanges:
       - file: meshviewer_create_srv_www
