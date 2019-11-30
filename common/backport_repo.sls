{% if salt['grains.get']('osfinger') == 'Debian-9' %}
debian_backports:
  pkgrepo.managed:
    - humanname: debian_backports
    - name: deb http://ftp.debian.org/debian stretch-backports main
    - file: /etc/apt/sources.list.d/backports.list
{% endif %}
{% if salt['grains.get']('osfinger') == 'Debian-10' %}
    - name: deb http://ftp.debian.org/debian buster-backports main
    - file: /etc/apt/sources.list.d/backports.list
{% endif %}