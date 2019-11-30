debian_backports:
  pkgrepo.managed:
    - humanname: debian_backports
    - name: deb http://ftp.debian.org/debian {{ salt['grains.get']('oscodename') }}-backports main
    - file: /etc/apt/sources.list.d/backports.list