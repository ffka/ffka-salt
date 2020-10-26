netdatarequisites:
  pkg.installed:
    - pkgs:
      - autoconf
      - autoconf-archive
      - automake
      - autogen
      - make
      - git
      - curl
      - gcc
      - zlib1g-dev
      - uuid-dev
      - libmnl-dev
      - libuv1-dev
      - netcat-traditional
      - pkg-config
      - libelf-dev

https://github.com/firehol/netdata.git:
  git.latest:
    - depth: 1
    - rev: master
    - target: /root/netdatagit
    - force_reset: True
    - force_fetch: True
    - require:
      - pkg: netdatarequisites

netdatainstall:
  require:
    - git: https://github.com/firehol/netdata.git
    - pkg: netdatarequisites
  cmd.run:
    - cwd: /root/netdatagit
    - name: /bin/bash netdata-installer.sh --dont-wait --auto-update
    - unless: test -f /usr/libexec/netdata/netdata-updater.sh

netdataupdate:
  require:
    - cmd: netdatainstall
  cmd.run:
    - cwd: /root/netdatagit
    - name: /bin/bash /usr/libexec/netdata/netdata-updater.sh
    - onlyif: test -f /usr/libexec/netdata/netdata-updater.sh
    - env:
      - NETDATA_NOT_RUNNING_FROM_CRON: '1'
    - onchanges:
      - git: https://github.com/firehol/netdata.git

{% for file in ["stream", "netdata", "python.d"] %}
/etc/netdata/{{ file }}.conf:
  file.managed:
    - source: salt://netdata/files/{{ file }}.conf.j2
    - user: root
    - group: netdata
    - template: jinja
    - require:
      - cmd: netdatainstall
      - cmd: netdataupdate
{% endfor %}

netdata.service:
  service.running:
    - name: netdata
    - enable: True
    - restart: True
    - require:
      - cmd: netdatainstall
      - cmd: netdataupdate
    - watch:
      - file: /etc/netdata/*
      - git: https://github.com/firehol/netdata.git
