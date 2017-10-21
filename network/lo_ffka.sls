gre_ffrl network interface:
  file.managed:
    - name: /etc/network/interfaces.d/lo_ffka.cfg
    - makedirs: true
    - user: root
    - group: root
    - mode: 660
    - source: salt://network/files/lo_ffka.j2
    - template: jinja
