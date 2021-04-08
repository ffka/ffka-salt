netdata.service:
  service.dead:
    - name: netdata
    - onlyif:
      - test -f /usr/libexec/netdata/netdata-uninstaller.sh


netdata-uninstall:
  cmd.run:
    - onlyif:
      - test -f /usr/libexec/netdata/netdata-uninstaller.sh
    - cwd: /root/netdatagit
    - name: /usr/libexec/netdata/netdata-uninstaller.sh --yes
    - require:
      - service: netdata.service

/root/netdatagit:
  file.absent:
    - require:
      - cmd: netdata-uninstall

/etc/netdata:
  file.absent:
    - require:
      - cmd: netdata-uninstall

