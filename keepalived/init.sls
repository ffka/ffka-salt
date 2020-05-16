keepalived:
  pkg.installed

/etc/keepalived/keepalived.conf:
  file.managed:
    - source: salt://keepalived/files/keepalived.conf
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

keepalived.service:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - pkg: keepalived
      - file: /etc/keepalived/keepalived.conf
