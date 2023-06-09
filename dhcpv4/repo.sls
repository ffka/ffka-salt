kea-repo:
  pkgrepo.managed:
    - humanname: kea-repo
    - name: deb https://dl.cloudsmith.io/public/isc/kea-2-2/deb/debian bullseye main
    - file: /etc/apt/sources.list.d/kea.list
    - gpgcheck: 1
    - key_url: https://dl.cloudsmith.io/public/isc/kea-2-2/gpg.A8CB727C62565FF8.key

/etc/apt/preferences.d/isc-kea:
  file.managed:
    - contents: |
        Package: isc-kea*
        Pin: release o=cloudsmith/isc/kea-2-2
        Pin-Priority: 800
