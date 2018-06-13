he-tunnel interfaces config:
  file.managed:
    - name: /etc/network/interfaces.d/he_tunnel.cfg
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - source: salt://network/files/he_tunnel.j2
    - template: jinja
