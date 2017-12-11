gluon-firmware-wizard:
  git.latest:
    - name: https://github.com/freifunk-darmstadt/gluon-firmware-wizard.git
    - target: /srv/www/firmware/htdocs
    - user: www-data
    - require:
      - file: /srv/www/firmware/htdocs/

gluon-firmware-wizard/config.js:
  file.managed:
    - name: /srv/www/firmware/htdocs/config.js
    - source: salt://nginx/files/sites/firmware/config.js.j2
    - template: jinja
    - mode: 644
    - user: www-data
    - group: www-data
    - require:
      - git: gluon-firmware-wizard

/srv/firmware/images/:
  file.directory:
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - makedirs: True

{% for dir in ["stable", "beta", "experimental"] %}
{{ "/srv/firmware/images/" ~ dir ~ "/" }}:
  file.directory:
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - require:
      - file: /srv/firmware/images/
{% endfor %}