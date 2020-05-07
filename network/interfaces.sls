{% if salt['pillar.get']('network:interfaces', False) %}
/etc/network/interfaces.d/50-interfaces:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://network/files/interfaces
    - template: jinja
{% endif %}

{% if salt['pillar.get']('network:nameservers', False) %}
/etc/resolv.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        {%- for ns in salt['pillar.get']('network:nameservers', []) %}
        nameserver {{ ns }}
        {%- endfor %}
{% endif %}

