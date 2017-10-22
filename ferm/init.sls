install ferm:
  pkg.installed:
    - name: ferm

/etc/default/ferm:
  file.managed:
    - name: /etc/ferm/ferm.conf
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - source: salt://ferm/files/ferm.conf.j2
    - template: jinja
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}

/etc/systemd/system/ferm.service:
  file.managed:
    - source: salt://ferm/files/ferm.service
    - user: root
    - group: root
    - mode: 644

service ferm:
  service.running:
    - name: ferm
    - enable: true
    - require:
      - file: /etc/systemd/system/ferm.service
