{% for hoodname,hood in salt['pillar.get']('hoods').items() if hoodname != "dflt" %}
{% for ip_type in [4, 6] %}

{% set if_name = hoodname ~ "_v" ~ ip_type %}
{% set if_mac = "00:00:00:{:02x}:{:02x}:{:02x}"|format(pillar['gw_id'], hood.hood_id, ip_type) %}

fastd config file {{ if_name }}:
  file.managed:
    - name: /etc/fastd/{{ if_name }}/fastd.conf
    - source: salt://mesh_vpn/files/fastd_hood.j2
    - makedirs: true
    - user: root
    - group: root
    - mode: 660
    - template: jinja
    - context:
        name: "{{ if_name }}"
        port: hood.fastd.port
        ip_type: v{{ ip_type }}
        mac: "{{ if_mac }}"
        hoodname: hoodname

fastd secret {{ if_name }}:
  file.managed:
    - name: /etc/fastd/{{ if_name }}/secret.conf
    - source: salt://mesh_vpn/files/secret.conf
    - makedirs: true
    - user: root
    - group: root
    - mode: 660
    - template: jinja

enable/run systemd {{ if_name }}:
  service.running:
    - name: fastd@{{ if_name }}
    - enable: true
    - watch:
      - file: /etc/fastd/{{ if_name }}/fastd.conf
      - file: /etc/fastd/{{ if_name }}/secret.conf
{% endfor %}
{% endfor %}

{% for interfaces in salt['pillar.get']('mesh_vpn:fastd:interfaces') %}
Fastd config file {{ interfaces.name }}:
  file.managed:
    - name: /etc/fastd/{{ interfaces.name }}/fastd.conf
    - source: salt://mesh_vpn/files/fastd.j2
    - makedirs: true
    - user: root
    - group: root
    - mode: 660
    - template: jinja
    - context:
        name: "{{ interfaces.name }}"
        bind: "{{ interfaces.bind }}"
        mac: "{{ interfaces.mac }}"

Fastd secret {{ interfaces.name }}:
  file.managed:
    - name: /etc/fastd/{{ interfaces.name }}/secret.conf
    - source: salt://mesh_vpn/files/secret.conf
    - makedirs: true
    - user: root
    - group: root
    - mode: 660
    - template: jinja

enable/run systemd {{ interfaces.name }}:
  service.running:
    - name: fastd@{{ interfaces.name }}
    - enable: true
    - watch:
      - file: /etc/fastd/{{ interfaces.name }}/fastd.conf
{% endfor %}

/etc/fastd/fastdbl:
  git.latest:
    - name: https://github.com/ffka/fastdbl.git
    - target: /etc/fastd/fastdbl
    - rev: just-bl
    - branch: just-bl
    - force_fetch: True
    - force_reset: True

include:
  - netdata.fastd
