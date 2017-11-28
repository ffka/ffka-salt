Fastd config file client:
  file.managed:
    - name: /etc/fastd/fastd.conf
    - source: salt://mesh_vpn/files/fastd_client.j2
    - makedirs: true
    - user: root
    - group: root
    - mode: 660
    - template: jinja
    - context:
        name: "{{ interfaces.name }}"
        bind: "{{ interfaces.bind }}"
        mac: "{{ interfaces.mac }}"

Fastd secret client:
  file.managed:
    - name: /etc/fastd/secret.conf
    - source: salt://mesh_vpn/files/secret.conf
    - makedirs: true
    - user: root
    - group: root
    - mode: 660
    - template: jinja

enable/run systemd fastd client:
  service.running:
    - name: fastd
    - enable: true
    - watch:
      - file: /etc/fastd/fastd.conf
