{% for name, settings in salt['pillar.get']('network:vrf', {}).items() %}
/etc/network/interfaces.d/00-vrf_{{ name }}:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source:
      - salt://network/files/vrf-{{ name }}
      - salt://network/files/vrf
    - template: jinja
    - context:
        name: {{ name }}
        settings: {{ settings | yaml }}

/etc/ferm/conf.d/urpf-vrf-{{ name }}.conf:
{%- if settings.get('routes', {}) | count > 0 %}
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://network/files/ferm.urpf-vrf.conf
    - template: jinja
    - require:
      - file: /etc/ferm/conf.d
    - watch_in:
      - service: ferm.service
    - context:
        name: {{ name }}
        settings: {{ settings | yaml }}
{%- else %}
  file.absent
{%- endif %}

{% endfor %}

/etc/network/interfaces.d/00-vrf-setup:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        auto dummy-vrf
        iface dummy-vrf inet manual
          pre-up ip link add $IFACE type dummy || true
          up (ip rule add pref 32765 table local ; ip rule del pref 0) || true
          up (ip -6 rule add pref 32765 table local ; ip -6 rule del pref 0) || true

{%- if salt['pillar.get']('network:default_vrf_cross_bind', False) %}
net.ipv4.tcp_l3mdev_accept:
  sysctl.present:
    - value: 1
    - config: /etc/sysctl.d/vrf.conf

net.ipv4.udp_l3mdev_accept:
  sysctl.present:
    - value: 1
    - config: /etc/sysctl.d/vrf.conf
{%- endif %}