nginx:
  pkg.installed:
    - pkgs:
      - nginx-extras

/etc/nginx/dhparams.pem:
  cmd.run:
    - name: openssl dhparam -out /etc/nginx/dhparams.pem 4096
    - onlyif: 'test ! -e /etc/nginx/dhparams.pem'
    - require:
      - pkg: nginx

nginx.service:
  service.running:
    - name: nginx
    - require:
      - pkg: nginx
      - cmd: /etc/nginx/dhparams.pem
      # Run certbot renew before updating the nginx service
      - test: hook_after_renew
    - enable: True
    - reload: True
    - watch:
      - file: /etc/nginx/sites-available/*
      - file: /etc/nginx/sites-enabled/*
      - file: /etc/nginx/snippets/*

/etc/nginx/sites-available/:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'
    - require:
      - pkg: nginx

/etc/nginx/snippets/:
  file.recurse:
    - source: salt://nginx/files/snippets
    - clean: True
    - file_mode: 0644
    - dir_mode: '0755'
    - template: jinja
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/default:
  file.absent:
    - require:
      - pkg: nginx

{% if salt['pillar.get']('nginx:default_server:domainset') %}
{% set default_certificate_name = salt['pillar.get']('domainsets:' ~ pillar['nginx']['default_server']['domainset'], [])[0] -%}
{% endif %}

/etc/nginx/sites-available/default.conf:
  file.managed:
    - source: salt://nginx/files/default.conf.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    {% if default_certificate_name is defined %}
    - context:
        certificate_filename: {{ default_certificate_name }}
    {% endif %}
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/default.conf:
  file.symlink:
    - target: /etc/nginx/sites-available/default.conf
    - require:
      - file: /etc/nginx/sites-available/default.conf

/etc/nginx/sites-available/stub_status.conf:
  file.managed:
    - source: salt://nginx/files/stub_status.conf.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/stub_status.conf:
  file.symlink:
    - target: /etc/nginx/sites-available/stub_status.conf
    - require:
      - file: /etc/nginx/sites-available/stub_status.conf

include:
  - snakeoil-cert
  - nginx.vhosts
