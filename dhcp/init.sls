install isc-dhcp-server:
  pkg.installed:
    - name: isc-dhcp-server

DHCPD config file:
  file.managed:
    - name: /etc/dhcp/dhcpd.conf
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - source: salt://dhcp/files/dhcpd.conf.j2
    - template: jinja
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}
        dhcp: {{ pillar['dhcp'] }}


service isc-dhcp-server:
  service.running:
    - name: isc-dhcp-server
    - enable: true
    - require:
      - file: /etc/dhcp/dhcpd.conf
