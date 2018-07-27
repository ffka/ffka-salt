{% for domain_id, domain in salt['pillar.get']('domains', {}).items() %}
{% for fastd in domain.get('fastd', {}).get('instances', []) %}

{%- set fastd_ifname = salt['domain_networking.generate_ifname'](domain, 'fastd', fastd['name']) %}

/etc/fastd/{{ fastd_ifname }}:
  file.directory:
    - mode: 755
    - makedirs: True
    - require:
      - pkg: fastd

/etc/fastd/{{ fastd_ifname }}/fastd.conf:
  file.managed:
    - source: salt://fastd/files/fastd_domain.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - context:
        domain: {{ domain }}
        fastd: {{ fastd }}
        fastd_id: {{ loop.index0 }}
    - require:
      - file: /etc/fastd/{{ fastd_ifname }}

{% endfor %}
{% endfor %}
