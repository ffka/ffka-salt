/etc/apt/preferences.d/testing:
  file.managed:
    - contents: |
        Package: *
        Pin: release a=testing
        Pin-Priority: 300

testing:
  pkgrepo.managed:
    - humanname: testing
    - name: deb http://ftp.debian.org/debian testing main
    - file: /etc/apt/sources.list.d/testing.list
    - require:
      - file: /etc/apt/preferences.d/testing