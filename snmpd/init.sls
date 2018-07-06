snmpd:
  pkg.installed

/etc/snmp/snmpd.conf:
  file.managed:
    - source: salt://snmpd/files/snmpd.conf.j2
    - user: root
    - group: root
    - mode: 0644
    - template: jinja
    - require:
      - pkg: snmpd

snmpd.service:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - file: /etc/snmp/snmpd.conf
    - require:
      - pkg: snmpd
      - file: /etc/snmp/snmpd.conf