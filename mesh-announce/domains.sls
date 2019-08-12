{% for domain_id, domain in salt['domain_networking.get_domains']().items() %}
/etc/mesh-announce/{{ domain_id }}.env:
  file.managed:
    - source: salt://mesh-announce/files/domain.env.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
        domain: {{ domain }}
        domain_id: {{ domain_id }}
    - require:
      - file: /etc/mesh-announce

mesh-announce@{{ domain_id }}.service:
  service.running:
    - enable: True
    - restart: True
    - require:
      - file: /etc/systemd/system/mesh-announce@.service
      - git: mesh-announce
      - file: /etc/mesh-announce/{{ domain_id }}.env
{% endfor %}