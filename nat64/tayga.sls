tayga:
  pkg.installed:
    - name: tayga

place tayga.conf:
  file.managed:
    - name: /etc/tayga.conf
    - source: salt://nat64/files/tayga.conf.j2
    - require:
      - pkg: tayga
    - template: jinja
    - context:
        v4_pool: {{ pillar['network']['nat64']['v4_pool'] }}
        v4_address: {{ pillar['network']['nat64']['v4_address'] }}
        v6_range: {{ pillar['network']['nat64']['v6_range'] }}

tayga_interface:
  cmd.script:
    - name: tayga_create_interface
    - source: salt://nat64/files/tayga_create_interface.sh.j2
    - template: jinja
    - cwd: /
    - require:
      - pkg: tayga
      - file: place tayga.conf

tayga.service:
  service.running:
    - name: tayga
    - enable: true
    - restart: true
    - require:
      - pkg: tayga
      - cmd: tayga_interface
      - file: place tayga.conf
    - watch:
      - file: place tayga.conf

setup tayga interface:
  cmd.script:
    - name: setup_tayga
    - require:
      - service: tayga.service
    - source: salt://nat64/files/setup_tayga.sh.j2
    - template: jinja
    - cwd: /
    - context:
        v4_pool: {{ pillar['network']['nat64']['v4_pool'] }}
        v4_address: {{ pillar['network']['nat64']['v4_address'] }}
        v4_interface_address: {{ pillar['network']['nat64']['v4_interface_address'] }}
        v6_range: {{ pillar['network']['nat64']['v6_range'] }}
        v6_interface_address: {{ pillar['network']['nat64']['v6_interface_address'] }}
