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
      - netcat
      - pkg-config

netdatarepo:
  git.latest:
    - name: https://github.com/firehol/netdata.git
    - depth: 1
    - rev: master
    - target: /root/netdatagit
    - force_reset: True
    - require:
      - pkg: netdatarequisites

netdatainstall:
  require:
    - git: netdatarepo
    - pkg: netdatarequisites
  cmd.run:
    - cwd: /root/netdatagit
    - name: ./netdata-installer.sh --dont-wait --auto-update
    - unless: test -f ./netdata-updater.sh

netdataupdate:
  require:
    - cmd: netdatainstall
  cmd.run:
    - cwd: /root/netdatagit
    - name: ./netdata-updater.sh
    - onlyif: test -f ./netdata-updater.sh
    - onchanges:
      - git: netdatarepo

/etc/netdata/stream.conf:
  file.managed:
    - source: 'salt://netdata/files/stream.conf.j2'
    - user: root
    - group: netdata
    - mode: 644
    - template: jinja
    - require:
      - cmd: netdatainstall
      - cmd: netdataupdate

/etc/netdata/netdata.conf:
  file.managed:
    - source: 'salt://netdata/files/netdata.conf.j2'
    - user: root
    - group: netdata
    - template: jinja
    - require:
      - cmd: netdatainstall
      - cmd: netdataupdate

/etc/netdata/python.d.conf:
  file.managed:
    - source: 'salt://netdata/files/python.d.conf.j2'
    - user: root
    - group: netdata
    - template: jinja
    - require:
      - cmd: netdatainstall

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
      - git: netdatarepo
