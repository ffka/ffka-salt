/root/unms-install.sh:
  file.managed:
    - source: https://raw.githubusercontent.com/Ubiquiti-App/UNMS/master/install.sh
    - user: root
    - group: root
    - mode: 755
    - source_hash: 8145aa7129958c0fb3bcb4edd12e5c7e1aa5fbd2

unms_install:
  cmd.run:
    - name: /root/unms-install.sh
    - cwd: /root/
    - onlyif: test ! -f /home/unms/data/
    - require:
      - service: docker.service
      - file: /root/unms-install.sh

unms_update:
  cmd.run:
    - name: /root/unms-install.sh
    - cwd: /root/
    - onlyif: test -f /home/unms/data/
    - require:
      - service: docker.service
      - file: /root/unms-install.sh
      - cmd: unms_install