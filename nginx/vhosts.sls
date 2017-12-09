{% for name, vhost in pillar.get('nginx', {}).get('vhosts', {}).iteritems() %}

/etc/nginx/sites-available/{{ name }}.conf:
  file.managed:
    - source: salt://nginx/files/sites/{{ name }}.conf.j2
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
      hostname: '{{ name }}'
      hostnames: '{{ vhost.hostnames|join(' ') }}'
      vhost: {{ vhost }}
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/{{ name }}.conf:
{% if not vhost.get('disabled', False) %}
  file.symlink:
    - target: /etc/nginx/sites-available/{{ name }}.conf
{% else %}
  file.absent
{% endif %}

/srv/www/{{ name }}:
  file.directory:
    - user: www-data
    - makedirs: True

/var/log/nginx/{{ name }}:
  file.directory:
    - user: www-data

{% endfor %}
