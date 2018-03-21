ebtables:
  pkg.installed


ferm:
  pkg.installed

/etc/ferm/conf.d:
  file.directory:
    - user: root
    - group: root
    - require:
      - pkg: ferm

/etc/ferm/conf.d/.keep:
  file.managed:
    - require:
      - file: /etc/ferm/conf.d

/etc/ferm/ferm.conf:
  file.managed:
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - source: salt://ferm/files/ferm.conf.j2
    - template: jinja
    - require:
      - pkg: ferm

/etc/systemd/system/ferm.service:
  file.managed:
    - source: salt://ferm/files/ferm.service
    - user: root
    - group: root
    - mode: 644

ferm.service:
  service.running:
    - name: ferm
    - enable: true
    - reload: true
    - require:
      - file: /etc/systemd/system/ferm.service
      - pkg: ferm
    - watch:
      - file: /etc/ferm/ferm.conf
      - file: /etc/ferm/conf.d/*