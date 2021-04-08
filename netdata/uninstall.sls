netdata.service:
  service.dead:
    - name: netdata
    - onlyif:
      - test -f /usr/libexec/netdata/netdata-uninstaller.sh


netdata-uninstall:
  cmd.run:
    - onlyif:
      - test -f /usr/libexec/netdata/netdata-uninstaller.sh
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


{% for file in ["netdata-updater.service", "netdata-updater.timer", "netdata.service"] %}
/lib/systemd/system/{{ file }}:
  file.absent:
    - require:
      - cmd: netdata-uninstall
{% endfor %}

/etc/cron.daily/netdata-updater:
  file.absent:
    - require:
      - cmd: netdata-uninstall

/usr/lib/netdata:
  file.absent:
    - require:
      - cmd: netdata-uninstall

{% for file in ["netdata-claim.sh", "netdata", "netdatacli"] %}
/usr/sbin/{{ file }}:
  file.absent:
    - require:
      - cmd: netdata-uninstall
{% endfor %}
