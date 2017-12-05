install nginx:
  pkg.installed:
    - pkgs:
      - nginx-extras

control nginx service:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch:
      - file: /etc/nginx/sites-available/*
      - file: /etc/nginx/sites-enabled/*
      - file: /etc/nginx/snippets/*
      - file: /etc/nginx/conf.d/*
