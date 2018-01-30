/root/unms-install.sh:
  file.managed:
    - source: https://raw.githubusercontent.com/Ubiquiti-App/UNMS/master/install.sh
    - user: root
    - group: root
    - mode: 755
    - source_hash: 8145aa7129958c0fb3bcb4edd12e5c7e1aa5fbd2

install unms:
  cmd.run:
    - name: unms-install.sh
    - cwd: /root/
    - require:
      - service: docker.service
      - file: /root/unms-install.sh