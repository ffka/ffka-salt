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
      # Run renew, which will run initial cert setup, before reloading nginx
      - cmd: renew
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
    - mode: 755
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - require:
      - pkg: nginx

/etc/nginx/snippets/:
  file.recurse:
    - source: salt://nginx/files/snippets
    - clean: True
    - file_mode: 0644
    - dir_mode: 0755
    - template: jinja
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/default:
  file.absent:
    - require:
      - pkg: nginx

{%- set default_domainset = salt['pillar.get']('domainsets:' ~ pillar['nginx']['default_server']['domainset'], []) -%}
/etc/nginx/sites-available/default.conf:
  file.managed:
    - source: salt://nginx/files/default.conf.j2
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
        certificate_filename: {{ default_domainset[0] }}
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/default.conf:
  file.symlink:
    - target: /etc/nginx/sites-available/default.conf
    - require:
      - file: /etc/nginx/sites-available/default.conf

include:
  - nginx.vhosts
