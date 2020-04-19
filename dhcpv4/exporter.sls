kea-exporter:
  pip.installed:
    - bin_env: '/usr/bin/pip3'
    - require:
      - pkg: packages_base