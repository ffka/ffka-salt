{% for domain_id, domain in salt['pillar.get']('domains', {}).items() %}
{% for fastd_id, fastd in enumerate(domain.get('fastd', {}).get('instances', [])) %}

/etc/fastd/{{ domain_id }}/{{ fastd['name'] }}:
  file.directory:
    - mode: 755
    - makedirs: True
    - require:
      - pkg: fastd

/etc/fastd/{{ domain_id }}/{{ fastd['name'] }}/fastd.conf:
  file.managed:
    - source: salt://fastd/files/fastd_domain.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - context:
        domain: {{ domain }}
        fastd: {{ fastd }}
        fastd_id: {{ fastd_id }}
    - require:
      - file: /etc/fastd/{{ domain_id }}/{{ fastd['name'] }}

#enable/run systemd fastd@{{ if_name }}:
#  service.running:
#    - name: fastd@{{ if_name }}
#    - enable: true
#    - watch:
#      - file: /etc/fastd/{{ if_name }}/fastd.conf
#      - file: /etc/fastd/{{ if_name }}/secret.conf
# git: /etc/fastd/fastdbl
{% endfor %}
{% endfor %}
