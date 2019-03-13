unattended-upgrades:
  pkg.installed:
    - pkgs:
      - unattended-upgrades
      - apt-listchanges

/etc/systemd/system/apt-daily-upgrade.timer.d:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755

/etc/systemd/system/apt-daily-upgrade.timer.d/upgrade-time.conf:
  file.managed:
    - contents: |
        [Timer]
        OnCalendar=
        OnCalendar=*-*-* 3:30:00
        RandomizedDelaySec=5min
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/systemd/system/apt-daily-upgrade.timer.d

{% for config in ["02periodic", "20auto-upgrades", "50unattended-upgrades"] %}
/etc/apt/apt.conf.d/{{ config }}:
  file.managed:
    - source: salt://apt/files/{{ config }}
    - template: jinja
    - user: root
    - group: root
    - mode: 644
{% endfor %}

daemon-reload @ apt-daily-upgrade.timer:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/apt-daily-upgrade.timer.d/upgrade-time.conf
