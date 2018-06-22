{% set jool_version = 'current' %}

jool-build-deps:
  pkg.installed:
    - pkgs:
      - build-essential
      - git
      - dkms

jool_src:
  git.latest:
    - name: https://github.com/NICMx/Jool.git
    - target: /usr/src/jool-{{ jool_version }}
    - rev: v3.5.7
    - require:
      - pkg: jool-build-deps
