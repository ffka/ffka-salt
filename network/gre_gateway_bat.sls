gre_gateway_bat network interface:
  file.managed:
    - name: /etc/network/interfaces.d/gre_gateway_bat.cfg
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - source: salt://network/files/gre_gateway_bat.j2
    - template: jinja
