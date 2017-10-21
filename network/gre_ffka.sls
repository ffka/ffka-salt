gre_ffka network interface:
  file.managed:
    - name: /etc/network/interfaces.d/gre_ffka.cfg
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - source: salt://network/files/gre_ffka.j2
    - template: jinja
