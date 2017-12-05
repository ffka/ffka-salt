nginx:
  pkg.installed:
    - pkgs:
      - nginx-extras

nginx.service:
  service.running:
    - name: nginx
    - require:
      - pkg: nginx
    - enable: True
    - reload: True
    - watch:
      - file: /etc/nginx/sites-available/*
      - file: /etc/nginx/sites-enabled/*

include:
  - nginx.vhosts
