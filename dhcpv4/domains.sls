/etc/kea/dhcp4-domains:
  file.directory:
    - mode: 755
    - makedirs: True
    - require:
      - pkg: kea-dhcp4-server

{%- set community_id = pillar.community_id %}
{% for domain_id, domain in salt['domain_networking.get_domains']().items() %}
{% set ifname_br = salt['domain_networking.generate_ifname'](community_id, domain, 'br') -%}
dhcpv4 @ {{ ifname_br }}:
  file.accumulated:
    - name: dhcpv4-interfaces
    - filename: /etc/kea/kea-dhcp4.conf
    - text: {{ ifname_br }}
    - require_in:
        - file: /etc/kea/kea-dhcp4.conf

/etc/kea/dhcp4-domains/{{ domain_id }}.conf:
  file.managed:
    - source: salt://dhcpv4/files/domain.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - context:
      domain: {{ domain }}
    - require:
      - pkg: kea-dhcp4-server
      - file: /etc/kea/dhcp4-domains
    - watch_in:
      - service: kea-dhcp4-server.service

dhcpv4 include config file /etc/kea/dhcp4-domains/{{ domain_id }}.conf:
  file.accumulated:
    - name: dhcpv4-subnets
    - filename: /etc/kea/kea-dhcp4.conf
    - text: /etc/kea/dhcp4-domains/{{ domain_id }}.conf
    - require_in:
        - file: /etc/kea/kea-dhcp4.conf
{% endfor %}