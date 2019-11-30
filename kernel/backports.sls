/etc/apt/preferences.d/{{ salt['grains.get']('oscodename') }}-backports-kernel:
  file.managed:
    - source: salt://kernel/files/{{ salt['grains.get']('oscodename') }}-backports-kernel
    - template: jinja

packages_kernel:
  pkg.latest:
    - fromrepo: {{ salt['grains.get']('oscodename') }}-backports
    - refresh: True
    - pkgs:
      - linux-image-amd64
      - linux-headers-amd64
    - require:
      - pkgrepo: debian_backports
      - file: /etc/apt/preferences.d/{{ salt['grains.get']('oscodename') }}-backports-kernel
