stretch_backports:
  pkgrepo.managed:
    - humanname: stretch_backports
    - name: deb http://ftp.debian.org/debian stretch-backports main
    - file: /etc/apt/sources.list.d/backports.list


packages_kernel:
  pkg.latest:
    - fromrepo: deb http://ftp.debian.org/debian stretch-backports main
    - pkgs:
      - linux-image-amd64
      - linux-headers-amd64
