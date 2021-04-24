/etc/apt/preferences.d/wireguard:
  file.managed:
    - contents: |
        Package: wireguard
        Pin: release a=unstable
        Pin-Priority: 800
        Package: wireguard-dkms
        Pin: release a=unstable
        Pin-Priority: 800
        Package: wireguard-tools
        Pin: release a=unstable
        Pin-Priority: 800

wireguard:
  pkg.installed:
    - require:
      - file: /etc/apt/preferences.d/wireguard
      - pkgrepo: unstable

/etc/wireguard:
  file.directory:
    - user: root
    - group: root
    - require:
      - pkg: wireguard

{% for tunnels in salt['pillar.get']('network:tunnel', {}).values() %}
{% for name, tunnel in tunnels.items() if tunnel['type'] == 'wireguard' %}
/etc/wireguard/wg-{{ name }}.conf:
  file.managed:
    - source:
      - salt://network/files/wireguard.conf
    - template: jinja
    - context:
        name: {{ name | yaml }}
        tunnel: {{ tunnel | yaml }}
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: wireguard
      - file: /etc/wireguard
{% endfor %}
{% endfor %}

/etc/ferm/conf.d/wireguard.conf:
  file.absent

/etc/network/interfaces.d/wireguard:
  file.absent

include:
  - common.debian_unstable
