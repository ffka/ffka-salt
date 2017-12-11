gluon-firmware-wizard:
  git.latest:
    - name: https://github.com/freifunk-darmstadt/gluon-firmware-wizard.git
    - target: /srv/www/firmware/htdocs
    - require:
      - file: /srv/www/firmware/htdocs/

gluon-firmware-wizard/config.js:
  file.managed:
    - name: /srv/www/firmware/htdocs/config.js
    - source: salt://nginx/files/sites/firmware/config.js
    - mode: 644
    - require:
      - git: gluon-firmware-wizard