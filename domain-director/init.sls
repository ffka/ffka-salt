director:
  user.present:
    - home: /var/lib/director
    - shell: /usr/sbin/nologin

director builddeps:
  pkg.installed:
    - pkgs:
      - libsqlite3-dev
      - libgeos-dev

https://github.com/freifunk-darmstadt/ffda-domain-director.git:
  git.latest:
    - target: /var/lib/director/domain-director
    - user: director
    - force_fetch: True
    - force_reset: True
    - refspec_branch: pr-refactor
    - require:
      - user: director
    - require_in:
      - service: domain-director.service
    - watch_in:
      - service: domain-director.service

/var/lib/director/venv:
  virtualenv.managed:
    - user: director
    - venv_bin: virtualenv
    - python: /usr/bin/python3
    - pip_upgrade: True
    - pip_pkgs:
      - click
      - flask
      - waitress
      - fastkml
      - geojson
      - mozls
      - peewee
      - pyyaml
      - requests
      - shapely
      - apscheduler
      - pymeshviewer
    - require:
      - user: director
      - pkg: director builddeps
    - require_in:
      - service: domain-director.service
    - watch_in:
      - service: domain-director.service

/etc/systemd/system/domain-director.service:
  file.managed:
    - source: salt://domain-director/files/domain-director.service
    - user: root
    - group: root
    - mode: 0644
    - require_in:
      - service: domain-director.service
    - watch_in:
      - service: domain-director.service

/etc/domain-director/config.yml:
  file.managed:
    - source: salt://domain-director/files/config.yml
    - user: root
    - group: root
    - mode: 0644
    - makedirs: True
    - require_in:
      - service: domain-director.service
    - watch_in:
      - service: domain-director.service

/etc/domain-director/domains.geojson:
  file.managed:
    - source: salt://domain-director/files/domains.geojson
    - user: root
    - group: root
    - mode: 0644
    - makedirs: True
    - require_in:
      - service: domain-director.service
    - watch_in:
      - service: domain-director.service

domain-director.service:
  service.running:
    - enable: True
