unbound:
  pkg.installed:
    - pkg:
      - unbound
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/unbound/unbound.conf


/etc/unbound/unbound.conf.d/ffka.conf:
  file.managed:
    - source: salt://unbound/files/unbound.conf.j2
    - user: root
    - group: root
    - mode: 644
    - template: jinja
