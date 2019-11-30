{% if salt['grains.get']('osfinger') == 'Debian-9' %}
stretch_backports:
  pkgrepo.managed:
    - humanname: stretch_backports
    - name: deb http://ftp.debian.org/debian stretch-backports main
    - file: /etc/apt/sources.list.d/backports.list
{% endif %}

{% if salt['grains.get']('osfinger') == 'Debian-10' %}
buster_backports:
  pkgrepo.managed:
    - humanname: stretch_backports
    - name: deb http://ftp.debian.org/debian stretch-backports main
    - file: /etc/apt/sources.list.d/backports.list
{% endif %}