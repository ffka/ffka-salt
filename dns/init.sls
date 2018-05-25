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

/etc/bind/id_deploy:
  file.managed:
    - user: root
    - mode: 600
    - contents_pillar: dns:deployment_key
    - require:
      - pkg: bind9

/etc/bind/dns:
  git.latest:
    - name: {{ pillar.dns.zones_repo }}
    - branch: master
    - target: /etc/bind/dns
    - identity: /etc/bind/id_deploy
    - force_reset: True
    - require:
       - pkg: packages_base
       - pkg: bind9
       - file: /etc/bind/id_deploy

/etc/bind/named.conf.zones:
  file.symlink:
    - target: /etc/bind/dns/named.conf.zones
    - require:
      - git: /etc/bind/dns


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
