gre_ffffm_uplink network interface:
  file.managed:
    - name: /etc/network/interfaces.d/gre_ffffm_uplink.cfg
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - source: salt://network/files/gre_ffffm_uplink.j2
    - template: jinja
