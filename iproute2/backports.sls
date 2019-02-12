/etc/apt/preferences.d/stretch-backports-iproute2:
  file.managed:
    - contents: |
        Package: iproute2
        Pin: release n=stretch-backports
        Pin-Priority: 800

iproute2:
  pkg.latest:
    - fromrepo: stretch-backports
    - refresh: True
    - pkgs:
      - iproute2
    - require:
      - pkgrepo: stretch_backports
      - file: /etc/apt/preferences.d/stretch-backports-iproute2
