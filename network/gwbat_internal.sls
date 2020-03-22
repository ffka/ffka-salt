/etc/network/interfaces.d/gwbat-internal:
  file.managed:
    - source: salt://network/files/gwbat_interfaces.j2
    - template: jinja
    - mode: '0644'
    - user: root
    - group: root
