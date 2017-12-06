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
      - file: /etc/nginx/snippets

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

/etc/nginx/snippets:
  file.recurse:
    - source: salt://nginx/files/snippets
    - clean: True
    - file_mode: 0644
    - dir_mode: 0755
    - require:
      - pkg: nginx

include:
  - nginx.vhosts
