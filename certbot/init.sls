certbot:
  pkg.installed:
    - pkgs:
      - certbot

/etc/letsencrypt/cli.ini:
  file.managed:
    - source: salt://letsencrypt/files/cli.ini.j2
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - template: jinja
    - require:
      - pkg: certbot
