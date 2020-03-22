{% for domain_id, domain in salt['domain_networking.get_domains']().items() %}
/etc/bird/bird6.d/62-radv-{{ domain_id }}.conf:
  file.managed:
    - source: salt://routing/files/bird6.d/gwbat/domains-radv.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: '0644'
    - context:
      domain_id: {{ domain_id }}
      domain: {{ domain }}
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/bird6.d
    - watch_in:
      - service: bird6
{% endfor %}