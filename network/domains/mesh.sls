{% for domain in salt['domain_networking.get_domains']().values() %}
/etc/network/interfaces.d/{{ salt['domain_networking.generate_ifname'](pillar.community_id, domain, None, 'mesh') }}:
  file.managed:
    - source: salt://network/files/domains/mesh_interfaces.j2
    - template: jinja
    - mode: '0644'
    - user: root
    - group: root
    - context:
        domain: {{ domain }}
{% endfor %}
