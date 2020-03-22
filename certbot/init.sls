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
    - mode: '0644'
    - makedirs: True
    - template: jinja
    - require:
      - pkg: certbot

certbot_webroot:
  file.directory:
    - name: {{ pillar['certbot']['webroot_path'] }}
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

# Perform initial setup for applicable domains
{% for name in salt['pillar.get']('certbot:domainsets', []) %}
{%- set domainlist = salt['pillar.get']('domainsets:' ~ name) -%}
certbot_certonly_initial_{{ name }}:
  cmd.run:
    - name: /usr/bin/certbot --text --non-interactive --expand certonly -d {{ domainlist|join(' -d ') }}
    - onlyif: 'test ! -e /etc/letsencrypt/live/{{ domainlist[0] }}/fullchain.pem'
    - require:
      - pkg: certbot
      - file: certbot_webroot
      - file: /etc/letsencrypt/cli.ini
    - require_in:
      - cmd: renew
{% endfor %}

# Renew manually
renew:
  cmd.run:
    - name: /usr/bin/certbot renew

# Dependency management: hook that can be used by other states (nginx) to wait for certificate init and renewal
hook_after_renew:
  test.nop:
    - require:
      - cmd: renew

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
    - mode: '0644'
    - require:
      - pkg: certbot

/etc/systemd/system/certbot.timer:
  file.managed:
    - source: salt://certbot/files/certbot.timer
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - pkg: certbot

/etc/systemd/system/certbot.service.d:
  file.directory:
    - user: root
    - group: root
    - dir_mode: '0755'

certbot.timer:
  service.running:
    - enable: True
    - require:
      - pkg: certbot
      - file: /etc/systemd/system/certbot.service
      - file: /etc/systemd/system/certbot.timer
      - file: /etc/letsencrypt/cli.ini

# Setup automatic reload of nginx on scheduled certbot run
/etc/systemd/system/certbot.service.d/nginx.conf:
  file.managed:
    - source: salt://certbot/files/nginx.conf
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - file: /etc/systemd/system/certbot.service.d
