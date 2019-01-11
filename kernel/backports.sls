/etc/apt/preferences.d/stretch-backports-kernel:
  file.managed:
    - source: salt://kernel/files/stretch-backports-kernel
    - template: jinja

packages_kernel:
  pkg.latest:
    - fromrepo: stretch-backports
    - refresh: True
    - pkgs:
      - linux-image-amd64
      - linux-headers-amd64
    - require:
      - pkgrepo: stretch_backports
      - file: /etc/apt/preferences.d/stretch-backports-kernel
