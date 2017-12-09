# Install certbot package and place configuration file
certbot:
  pkg.installed:
    - pkgs:
      - certbot

/etc/letsencrypt/cli.ini:
  file.managed:
    - source: salt://certbot/files/cli.ini.j2
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - template: jinja
    - require:
      - pkg: certbot

# Perform initial setup for applicable domains
{% for name, domainlist in pillar['certbot']['domainsets'].iteritems() %}
certbot_certonly_initial_{{ name }}:
  cmd.run:
    - name: /usr/bin/certbot --text --non-interactive --expand certonly -d {{ domainlist|join(' -d ') }}
{% endfor %}

# Setup automatic renewal using systemd timers (remove default cronjob)
/etc/cron.d/certbot:
  file.absent:
    - require:
      - pkg: certbot

/etc/systemd/system/certbot.service:
  file.managed:
    - source: salt://certbot/files/certbot.service
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: certbot

/etc/systemd/system/certbot.timer:
  file.managed:
    - source: salt://certbot/files/certbot.timer
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: certbot

/etc/systemd/system/certbot.service.d:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755

certbot.timer:
  service.running:
    - enable: True
    - require:
      - pkg: certbot
      - file: /etc/systemd/system/certbot.service
      - file: /etc/systemd/system/certbot.timer
      - file: /etc/letsencrypt/cli.ini