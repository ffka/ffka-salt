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
      - file: /etc/nginx/sites-available
      - file: /etc/nginx/sites-enabled

/etc/nginx/sites-available:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/etc/nginx/sites-enabled:
  file.directory:
    - user: root
    - group: root
    - mode: 755

include:
  - nginx.vhosts
