install radvd:
  pkg.installed:
    - name: radvd

radvd config file:
  file.managed:
    - name: /etc/radvd.conf
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - source: salt://radvd/files/radvd.conf.j2
    - template: jinja
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}
