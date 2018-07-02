fastd:
  pkg.latest:
    - fromrepo: stretch-backports
    - refresh: True

disable fastd autostart:
  file.replace:
    - name: /etc/default/fastd
    - pattern: ^AUTOSTART=(.*)$
    - repl: AUTOSTART="none"
    - require:
      - pkg: fastd