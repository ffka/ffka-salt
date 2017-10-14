br_ffwp network interface:
  file.managed:
    - name: /etc/network/interfaces.d/br_ffka.cfg
    - makedirs: true
    - user: root
    - group: root
    - mode: 660
    - source: salt://network/files/br_ffka.j2
    - template: jinja
