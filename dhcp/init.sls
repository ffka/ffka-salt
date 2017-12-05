install isc-dhcp-server:
  pkg.installed:
    - name: isc-dhcp-server


{% for dhcpd in ['dhcpd','dhcpd6'] %}
{{dhcpd}} config file:
  file.managed:
    - name: /etc/dhcp/{{dhcpd}}.conf
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - source: salt://dhcp/files/{{dhcpd}}.conf.j2
    - template: jinja
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}
        dhcp: {{ pillar['dhcp'] }}
    - watch_in:
      - service: isc-dhcp-server
{% endfor %}


/etc/default/isc-dhcp-server:
  file.managed:
    - source: salt://dhcp/files/isc-dhcp-server_default.j2
    - template: jinja
    - watch_in:
      - service: isc-dhcp-server


service isc-dhcp-server:
  service.running:
    - name: isc-dhcp-server
    - enable: true
    - require:
      - file: /etc/dhcp/dhcpd*.conf
      - file: /etc/default/isc-dhcp-server
