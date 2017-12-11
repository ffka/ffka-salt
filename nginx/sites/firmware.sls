gluon-firmware-wizard:
  git.latest:
    - name: https://github.com/freifunk-darmstadt/gluon-firmware-wizard.git
    - target: /srv/www/firmware/gluon-firmware-wizard
    - require:
      - file: /srv/www/firmware/htdocs/