/etc/ferm/conf.d/nat.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        {% for interface_name, interface in salt['pillar.get']('address_assignment', {}).items() %}
        {%- for ipv4_net, config in interface.get('ipv4', {}).items() if config.get('nat', False) %}
        # SNAT for {{ ipv4_net }} on {{ interface_name }} to {{ config['nat']['to_source'] }} @ {{ config['nat']['outgoing_interface'] }}
        domain ip table nat chain POSTROUTING {
            source {{ ipv4_net }} outerface {{ config['nat']['outgoing_interface'] }} SNAT to {{ config['nat']['to_source'] }};
        }
        {% endfor %}
        {%- endfor %}
    - require:
      - file: /etc/ferm/conf.d