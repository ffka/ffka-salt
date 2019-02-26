{% for interface_name, interface in salt['pillar.get']('address_assignment', {}).items() %}
/etc/bird/bird6.d/62-radv-{{ interface_name }}.conf:
  file.managed:
    - source: salt://routing/files/bird6.d/radv.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: 644
    - context:
      interface_name: {{ interface_name }}
      interface: {{ interface }}
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/bird6.d
    - watch_in:
      - service: bird6
{% endfor %}
