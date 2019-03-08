/etc/apt/preferences.d/unstable:
  file.managed:
    - contents: |
        Package: *
        Pin: release a=unstable
        Pin-Priority: 200

unstable:
  pkgrepo.managed:
    - humanname: unstable
    - name: deb http://ftp.debian.org/debian unstable main
    - file: /etc/apt/sources.list.d/unstable.list
    - require:
      - file: /etc/apt/preferences.d/unstable