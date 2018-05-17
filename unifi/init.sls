packages.ubnt.com:
  pkgrepo.managed:
    - humanname: unifi
    - name: deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti
    - dist: stable
    - file: /etc/apt/sources.list.d/ubnt-unifi.list
    - gpgcheck: 1
    - key_url: https://dl.ubnt.com/unifi/unifi-repo.gpg

unifi:
  pkg.installed:
    - pkgs:
      - unifi
    - require:
      - pkgrepo: packages.ubnt.com
