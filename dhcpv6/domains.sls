/etc/kea/dhcp6-domains:
  file.directory:
    - mode: '0755'
    - makedirs: True
    - require:
      - pkg: isc-kea-dhcp6-server

{%- set community_id = pillar.community_id %}
{% for domain_id, domain in salt['domain_networking.get_domains']().items() %}
{% set ifname_bat = salt['domain_networking.generate_ifname'](community_id, domain, 'bat') -%}
dhcpv6 @ {{ ifname_bat }}:
  file.accumulated:
    - name: dhcpv6-interfaces
    - filename: /etc/kea/kea-dhcp6.conf
    - text: {{ ifname_bat }}
    - require_in:
        - file: /etc/kea/kea-dhcp6.conf

/etc/kea/dhcp6-domains/{{ domain_id }}.conf:
  file.managed:
    - source: salt://dhcpv6/files/domain.conf.j2
    - template: jinja
    - user: _kea
    - group: _kea
    - mode: '0600'
    - context:
      domain: {{ domain }}
    - require:
      - pkg: isc-kea-dhcp6-server
      - file: /etc/kea/dhcp6-domains
    - watch_in:
      - service: isc-kea-dhcp6-server.service

dhcpv6 include config file /etc/kea/dhcp6-domains/{{ domain_id }}.conf:
  file.accumulated:
    - name: dhcpv6-subnets
    - filename: /etc/kea/kea-dhcp6.conf
    - text: /etc/kea/dhcp6-domains/{{ domain_id }}.conf
    - require_in:
        - file: /etc/kea/kea-dhcp6.conf
{% endfor %}