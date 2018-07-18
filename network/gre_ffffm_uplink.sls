gre_vzffnrmo network interface:
  file.managed:
    - name: /etc/network/interfaces.d/gre_vzffnrmo.cfg
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - source: salt://network/files/gre_vzffnrmo.j2
    - template: jinja
