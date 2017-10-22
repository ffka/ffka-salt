install fastd:
  pkg.latest:
    - name: fastd


{% for interfaces in salt['pillar.get']['meash_vpn']['fastd'] %}

Fastd template instance {{ interfaces.name }}:
  file.managed:
    - name: /etc/fastd/{{ interfaces.name }}/fastd.conf
    - makedirs: true
    - user: root
    - group: root
    - mode: 660
    - template: jinja
    - context:
      name: "{{ interfaces.name }}"
      bind: "{{ interfaces.bind }}"
      mac: "{{ interfaces.mac }}"

  file.managed:
    - name: /etc/fastd/{{ interfaces.name }}/secret.conf
    - makedirs: true
    - user: root
    - group: root
    - mode: 660
    - template: jinja
{% endfor %}
