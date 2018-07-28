/etc/kea/dhcp4-domains.conf:
  file.managed:
    - source: salt://dhcpv4/files/domains.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - watch_in:
      - service: kea-dhcp4-server.service

{% for domain in salt['pillar.get']('domains', {}).values() %}
{% set ifname_br = salt['domain_networking.generate_ifname'](domain, 'br') -%}
dhcpv4 @ {{ ifname_br }}:
  file.accumulated:
    - name: dhcpv4-interfaces
    - filename: /etc/kea/kea-dhcp4.conf
    - text: {{ ifname_br }}
    - require_in:
        - file: /etc/kea/kea-dhcp4.conf
{% endfor %}