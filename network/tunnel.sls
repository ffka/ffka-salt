{% for name, tunnels in salt['pillar.get']('network:tunnel', {}).items() %}

gre_{{ name }}:
  file.managed:
    - name: /etc/network/interfaces.d/gre_{{ name }}.cfg
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - source: salt://network/files/tunnel.j2
    - template: jinja
    - context:
        tunnels: {{ tunnels }}

{% endfor %}