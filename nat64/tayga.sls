# Basic setup
tayga:
  pkg.installed:
    - name: tayga

/etc/tayga.conf:
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
      - file: /etc/tayga.conf

# Use systemd instead of the provided init script
/etc/init.d/tayga:
  file.absent:
    - require:
      - pkg: tayga

tayga.service:
  file.managed:
    - name: /etc/systemd/system/tayga.service
    - source: salt://nat64/files/tayga.service.j2
    - require:
      - pkg: tayga
    - template: jinja
  service.running:
    - name: tayga
    - enable: true
    - restart: true
    - require:
      - pkg: tayga
      - cmd: tayga_interface
      - file: /etc/tayga.conf
      - file: /etc/init.d/tayga
      - file: /etc/systemd/system/tayga.service
    - watch:
      - file: /etc/tayga.conf

# Interface and routing setup
/usr/local/bin/tayga_setup.sh:
  file.managed:
    - require:
      - service: tayga.service
    - source: salt://nat64/files/setup_tayga.sh.j2
    - template: jinja
    - context:
        v4_pool: {{ pillar['network']['nat64']['v4_pool'] }}
        v4_address: {{ pillar['network']['nat64']['v4_address'] }}
        v4_interface_address: {{ pillar['network']['nat64']['v4_interface_address'] }}
        v6_range: {{ pillar['network']['nat64']['v6_range'] }}
        v6_interface_address: {{ pillar['network']['nat64']['v6_interface_address'] }}

tayga-setup.service:
  file.managed:
    - name: /etc/systemd/system/tayga-setup.service
    - require:
      - service: tayga.service
    - source: salt://nat64/files/tayga-setup.service.j2
    - template: jinja
  service.running:
    - name: tayga-setup
    - enable: true
    - restart: true
    - require:
      - file: /usr/local/bin/tayga_setup.sh
      - file: /etc/systemd/system/tayga-setup.service
    - watch:
      - file: /usr/local/bin/tayga_setup.sh
