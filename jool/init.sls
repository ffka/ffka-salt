{% set jool_version = 'current' %}

jool-build-deps:
  pkg.installed:
    - pkgs:
      - build-essential
      - git
      - dkms
      - linux-headers-{{ grains.kernelrelease }}

jool-src:
  git.latest:
    - name: https://github.com/NICMx/Jool.git
    - target: /usr/src/jool-{{ jool_version }}
    - rev: v3.5.7
    - require:
      - pkg: jool-build-deps

/usr/src/jool-{{ jool_version }}/dkms.package_version.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        PACKAGE_VERSION={{ jool_version }}
    - require:
      - git: jool-src

jool-dkms-add:
  cmd.run:
    - onchanges:
      - git: jool-src
    - require:
      - pkg: jool-build-deps
      - git: jool-src
      - file: /usr/src/jool-{{ jool_version }}/dkms.package_version.conf
    - name: dkms add -m jool -v {{ jool_version }}

jool-dkms-build:
  cmd.run:
    - onchanges:
      - cmd: jool-dkms-add
    - name: dkms build -m jool -v {{ jool_version }}

jool-dkms-install:
  cmd.run:
    - onchanges:
      - cmd: jool-dkms-build
    - name: dkms install -m jool -v {{ jool_version }}
