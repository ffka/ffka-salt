{% for domain_id, domain in salt['domain_networking.get_domains']().items() %}
{% for fastd in domain.get('fastd', {}).get('instances', []) %}

{%- set community_id = pillar.community_id %}
{% set fastd_ifname = salt['domain_networking.generate_ifname'](community_id, domain, 'fd', fastd['name']) %}

/etc/fastd/{{ domain_id }}/{{ fastd['name'] }}:
  file.directory:
    - mode: '0755'
    - makedirs: True
    - require:
      - pkg: fastd

/etc/fastd/{{ domain_id }}/{{ fastd['name'] }}/fastd.conf:
  file.managed:
    - source: salt://fastd/files/fastd_domain.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: '0600'
    - context:
        domain: {{ domain }}
        fastd: {{ fastd }}
        fastd_id: {{ loop.index0 }}
        fastd_ifname: {{ fastd_ifname }}
    - require:
      - file: /etc/fastd/{{ domain_id }}/{{ fastd['name'] }}

fastd@{{ domain_id }}-{{ fastd['name'] }}.service:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - file: /etc/fastd/{{ domain_id }}/{{ fastd['name'] }}/fastd.conf

#fastd@{{ domain_id }}-{{ fastd['name'] }} in fastd exporter:
#  file.accumulated:
#    - name: instances
#    - filename: /etc/default/prometheus-fastd-exporter
#    - text: {{ domain_id }}/{{ fastd['name'] }}
#    - require_in:
#        - file: /etc/default/prometheus-fastd-exporter

{% endfor %}
{% endfor %}
