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
    - target: /root/netdatagit
    - force_reset: True

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

netdatastream:
  file.managed:
    - name: '/etc/netdata/stream.conf'
    - source: 'salt://common/files/netdata/stream.conf.j2'
    - template: jinja
