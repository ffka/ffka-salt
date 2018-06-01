knot:
  pkgrepo.managed:
    - humanname: knot
    - name: deb https://deb.knot-dns.cz/knot/ {{ grains.lsb_distrib_codename }} main
    - key_url: https://deb.knot-dns.cz/knot/apt.gpg
    - file: /etc/apt/sources.list.d/knot.list
  pkg.installed: []

