lo_ffka network interface:
  file.managed:
    - name: /etc/network/interfaces.d/lo_core.cfg
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - source: salt://network/files/lo_core.j2
    - template: jinja
