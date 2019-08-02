ssl-cert:
  pkg.installed

ssl-cert-snakeoil:
  cmd.run:
    - name: make-ssl-cert generate-default-snakeoil
    - onchanges:
      - pkg: ssl-cert
