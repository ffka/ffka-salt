knot:
  pkgrepo.managed:
    - humanname: knot
    - name: deb https://deb.knot-dns.cz/knot/ {{ grains.lsb_distrib_codename }} main
    - key_url: https://deb.knot-dns.cz/knot/apt.gpg
    - file: /etc/apt/sources.list.d/knot.list
  pkg.installed: []
  user.present: []

{% for config_file in ["knot", "remotes", "templates", "acls", "dynamic"] %}
/etc/knot/{{ config_file }}.conf:
  file.managed:
    - source: salt://knot/files/{{ config_file }}.conf.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - require:
      - pkg: knot
    - watch_in:
      - service: knot.service
{% endfor %}

/etc/knot/id_deploy:
  file.managed:
    - user: root
    - mode: '0600'
    - contents_pillar: dns:deployment_key
    - require:
      - pkg: knot
    - watch_in:
      - service: knot.service

/etc/knot/zones:
  git.latest:
    - name: {{ pillar.dns.zones_repo }}
    - branch: master
    - target: /etc/knot/zones
    - identity: /etc/knot/id_deploy
    - force_reset: True
    - require:
       - pkg: packages_base
       - pkg: knot
       - file: /etc/knot/id_deploy
    - watch_in:
      - service: knot.service

{% for zone_type in ["master", "slave"] %}
/etc/knot/zones.{{ zone_type }}.conf:
  file.symlink:
    - target: /etc/knot/zones/knot.zones.{{ zone_type }}.conf
    - require:
      - pkg: knot
    - watch_in:
      - service: knot.service
{% endfor %}

knot.service:
  service.running:
    - enable: true
    - reload: true
