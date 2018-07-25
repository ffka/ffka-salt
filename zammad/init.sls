zammad-repo:
  pkgrepo.managed:
    - humanname: Zammad
    - name: deb https://dl.packager.io/srv/deb/zammad/zammad/stable/{{ salt['grains.get']('os')|lower }} {{ salt['grains.get']('osmajorrelease') }} main
    - file: /etc/apt/sources.list.d/zammad.list
    - gpgcheck: 1
    - key_url: https://dl.packager.io/srv/zammad/zammad/key

zammad:
  pkg.installed:
    - require:
      - pkgrepo: zammad-repo