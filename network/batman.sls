bat0 network interface:
  file.managed:
    - name: /etc/network/interfaces.d/batman.cfg
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - source: salt://network/files/batman.j2
    - template: jinja
