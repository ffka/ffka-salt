/etc/kea/dhcp4-domains:
  file.directory:
    - mode: '0755'
    - makedirs: True
    - require:
      - pkg: isc-kea-dhcp4-server

{%- set community_id = pillar.community_id %}
{% for domain_id, domain in salt['domain_networking.get_domains']().items() if domain.get('ipv4') %}
{% set ifname_bat = salt['domain_networking.generate_ifname'](community_id, domain, 'bat') -%}
dhcpv4 @ {{ ifname_bat }}:
  file.accumulated:
    - name: dhcpv4-interfaces
    - filename: /etc/kea/kea-dhcp4.conf
    - text: {{ ifname_bat }}
    - require_in:
        - file: /etc/kea/kea-dhcp4.conf

/etc/kea/dhcp4-domains/{{ domain_id }}.conf:
  file.managed:
    - source: salt://dhcpv4/files/domain.conf.j2
    - template: jinja
    - user: _kea
    - group: _kea
    - mode: '0600'
    - context:
      domain: {{ domain }}
    - require:
      - pkg: isc-kea-dhcp4-server
      - file: /etc/kea/dhcp4-domains
    - watch_in:
      - service: isc-kea-dhcp4-server.service

dhcpv4 include config file /etc/kea/dhcp4-domains/{{ domain_id }}.conf:
  file.accumulated:
    - name: dhcpv4-subnets
    - filename: /etc/kea/kea-dhcp4.conf
    - text: /etc/kea/dhcp4-domains/{{ domain_id }}.conf
    - require_in:
        - file: /etc/kea/kea-dhcp4.conf
{% endfor %}