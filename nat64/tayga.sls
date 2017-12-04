install tayga:
  pkg.installed:
    - name: tayga

place tayga.conf:
  file.managed:
    - name: /etc/tayga.conf
    - source: salt://nat64/files/tayga.conf.j2
    - template: jinja
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}
        dhcp: {{ pillar['dhcp'] }}


tayga --mktun:
  cmd.run:
    - name: tayga --mktun

service tayga:
  service.running:
    - name: tayga
    - enable: true
    - reload: true
    - watch:
      - file: place tayga.conf
