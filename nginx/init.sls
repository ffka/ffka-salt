install nginx:
  pkg.installed:
    - pkgs:
      - nginx-extras

control nginx service:
  service.running:
    - name: nginx
    - require:
      - pkg: install nginx
    - enable: True
    - reload: True
    - watch:
      - file: /etc/nginx/sites-available/*
      - file: /etc/nginx/sites-enabled/*
      - file: /etc/nginx/conf.d/*
