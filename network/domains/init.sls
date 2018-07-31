{% for domain in salt['pillar.get']('domains', {}).values() %}
/etc/network/interfaces.d/{{ salt['domain_networking.generate_ifname'](domain) }}:
  file.managed:
    - source: salt://network/files/domains/interfaces.j2
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
        domain: {{ domain }}
{% endfor %}