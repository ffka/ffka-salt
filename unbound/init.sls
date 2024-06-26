{%- from 'unbound/instances.map' import instances with context -%}

unbound:
  pkg.installed

dns-root-data:
  pkg.latest

unbound.service:
  service.dead:
    - enable: False
    - require:
      - pkg: unbound
      - pkg: dns-root-data

/etc/systemd/system/unbound@.service:
  file.managed:
    - source: salt://unbound/files/unbound@.service
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

/etc/apparmor.d/local/usr.sbin.unbound:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        {% for instance in salt['pillar.get']('unbound:instances') %}
        /{,var/}run/unbound-{{ instance }}.pid rw,
        /{,var/}run/unbound-{{ instance }}.ctl rw,
        {% endfor %}

apparmor.service:
  service.running:
    - reload: True
    - watch:
      - file: /etc/apparmor.d/local/usr.sbin.unbound

{% for instance, settings in salt['pillar.get']('unbound:instances').items() %}
/etc/unbound/{{ instance }}.conf.d:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'

/etc/unbound/{{ instance }}.conf:
  file.managed:
    - contents: |
        server:
            pidfile: "/var/run/unbound-{{ instance }}.pid"
            do-daemonize: no
        remote-control:
            control-interface: "/var/run/unbound-{{ instance }}.ctl"
        include: "/etc/unbound/{{ instance }}.conf.d/*.conf"
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - file: /etc/unbound/{{ instance }}.conf.d

{% set files = instances[instance].get('files', []) %}
{% for file in files %}
/etc/unbound/{{ instance }}.conf.d/{{ file }}.conf:
  file.managed:
    - source: salt://unbound/files/{{ file }}.conf
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'
    - context:
      settings: {{ settings | yaml }}
    - require:
      - file: /etc/unbound/{{ instance }}.conf.d
{% endfor %}

unbound@{{ instance }}.service:
  service.running:
    - enable: True
    - reload: True
    - require:
      - service: unbound.service
    - watch:
      - file: /etc/unbound/{{ instance }}.conf.d*
      - file: /etc/systemd/system/unbound@.service
{% endfor %}
