gre_ffrl network interface:
  file.managed:
    - name: /etc/network/interfaces.d/gre_ffrl.cfg
    - makedirs: true
    - user: root
    - group: root
    - mode: 660
    - source: salt://network/files/gre_ffrl.j2
    - template: jinja
