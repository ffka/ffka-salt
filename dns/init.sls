install bind9:
  pkg.installed:
    - name: bind9


place bind9 named.conf:
  file.managed:
    - name: /etc/bind/named.conf
    - source: salt://dns/files/named.conf.j2
    - template: jinja
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}


{% for subconfig in ['acl','default-zones','local','options','log'] %}
place bind9 named.conf.{{subconfig}}:
  file.managed:
    - name: /etc/bind/named.conf.{{subconfig}}
    - source: salt://dns/files/named.conf.{{subconfig}}.j2
    - template: jinja
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}
{% endfor %}
