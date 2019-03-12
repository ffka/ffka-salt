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
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/systemd/system/apt-daily-upgrade.timer.d

{% for config in ["02periodic", "20auto-upgrades"] %}
/etc/apt/apt.conf.d/{{ config }}:
  file.managed:
    - source: salt://apt/files/{{ config }}
    - user: root
    - group: root
    - mode: 644
{% endfor %}

unattended-upgrades-config:
  file.managed:
    - name: /etc/apt/apt.conf.d/50unattended-upgrades
    - source: salt://apt/files/50unattended-upgrades
    - template: jinja
    - user: root
    - group: root
    - mode: 644
