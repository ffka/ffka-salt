{% for interface_name, interface in salt['pillar.get']('address_assignment', {}).items() %}
/etc/bird/bird.d/62-radv-{{ interface_name }}.conf:
  file.managed:
    - source: salt://routing/files/bird2/bird.d/62-radv.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: '0644'
    - context:
      interface_name: {{ interface_name }}
      interface: {{ interface }}
    - watch_in:
      - service: bird.service
    - require:
      - pkg: bird2
      - file: /etc/bird/bird.d/
{% endfor %}
