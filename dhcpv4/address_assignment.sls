/etc/kea/dhcp4-interfaces:
  file.directory:
    - mode: 755
    - makedirs: True
    - require:
      - pkg: kea-dhcp4-server

{% for interface_name, domain in salt['pillar.get']('address_assignment', {}).items() %}
dhcpv4 @ {{ interface_name }}:
  file.accumulated:
    - name: dhcpv4-interfaces
    - filename: /etc/kea/kea-dhcp4.conf
    - text: {{ interface_name }}
    - require_in:
        - file: /etc/kea/kea-dhcp4.conf

/etc/kea/dhcp4-interfaces/{{ interface_name }}.conf:
  file.managed:
    - source: salt://dhcpv4/files/address_assignment.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - context:
      domain: {{ interface }}
    - require:
      - pkg: kea-dhcp4-server
      - file: /etc/kea/dhcp4-interfaces
    - watch_in:
      - service: kea-dhcp4-server.service

dhcpv4 include config file /etc/kea/dhcp4-domains/{{ interface_name }}.conf:
  file.accumulated:
    - name: dhcpv4-subnets
    - filename: /etc/kea/kea-dhcp4.conf
    - text: /etc/kea/dhcp4-interfaces/{{ interface_name }}.conf
    - require_in:
        - file: /etc/kea/kea-dhcp4.conf
{% endfor %}
