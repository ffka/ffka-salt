purge-radvd:
  pkg.purged:
    - pkgs:
      - radvd

place radv.conf:
  file.managed:
    - name: /etc/bird/bird.d/radv.conf
    - source: salt://radvd/files/radv.conf.j2
    - template: jinja
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}
