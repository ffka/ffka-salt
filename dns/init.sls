bind9:
  pkg.installed:
    - name: bind9
  service.running:
    - name: bind9
    - enable: True
    - watch:
       - file: /etc/bind/*.conf
       - file: /etc/bind/named.conf*
       - git: /etc/bind/dns

/var/log/bind:
  file.directory:
    - user: bind
    - group: bind
    - mode: 755
    - require:
      - pkg: bind9

{% for subconfig in ['', '.acl','.default-zones','.options','.log'] %}
place bind9 named.conf{{subconfig}}:
  file.managed:
    - name: '/etc/bind/named.conf{{ subconfig }}'
    - source: 'salt://dns/files/named.conf{{ subconfig }}.j2'
    - template: jinja
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}
{% endfor %}

/etc/logrotate.d/bind-rndc.conf:
  file.managed:
    - source: 'salt://dns/files/bind-rndc.conf.j2'
    - user: root
    - group: root
    - mode: 644
    - template: jinja
