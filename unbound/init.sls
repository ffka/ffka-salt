unbound:
  pkg.installed:
    - pkg:
      - unbound

unbound.service:
  service.dead:
    - enable: False
    - require:
      - pkg: unbound

/etc/systemd/system/unbound@.service:
  file.managed:
    - source: salt://unbound/files/unbound@.service
    - template: jinja
    - user: root
    - group: root
    - mode: 644

{% for instance, settings in salt['pillar.get']('unbound:instances').items() %}
/etc/unbound/{{ instance }}.conf.d:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/etc/unbound/{{ instance }}.conf:
  file.managed:
    - contents: |
        server:
            pidfile: "/var/run/unbound-{{ instance }}.pid"
        include: "/etc/unbound/{{ instance }}.conf.d/*.conf"
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/unbound/{{ instance }}.conf.d

/etc/unbound/{{ instance }}.conf.d/:
  file.recurse:
    - source: salt://unbound/files/{{ instance }}.conf.d/
    - clean: True
    - template: jinja
    - require:
      - file: /etc/unbound/{{ instance }}.conf.d

unbound@{{ instance }}.service:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/unbound/{{ instance }}.conf.d*
      - file: /etc/systemd/system/unbound@.service
{% endfor %}
