install ntp:
  pkg.installed:
    - name: ntp

service ntp:
  service.running:
    - name: ntp
    - enable: True
    - reload: True
    - require:
      - file: /etc/ntp.conf

place /etc/ntp.conf:
  file.managed:
    - name: /etc/ntp.conf
    - source: salt://ntp/files/ntp.conf
    - user: root
    - group: root
    - mode: '0644'
