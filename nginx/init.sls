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

include:
  - nginx.vhosts
