cloud network interfaces:
  file.managed:
    - name: /etc/network/interfaces.d/cloud_gateway.cfg
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - source: salt://network/files/cloud_gateway.j2
    - template: jinja
