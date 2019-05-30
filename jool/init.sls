# This state installs jool from source.
# We use a dummy version 'current' so the directories are more predictable
# and automation is easier. The version will always be replaced by a newer version.

{% set jool_version = 'current' %}
{% set jool_download_url = 'https://github.com/NICMx/Jool/releases/download/v4.0.1/jool_4.0.1.tar.gz' %}

jool-build-deps:
  pkg.installed:
    - pkgs:
      - build-essential
      - dkms
      - linux-headers-{{ grains.kernelrelease }}
      - pkg-config
      - libnl-genl-3-dev
      - libxtables-dev

jool-src:
  file.managed:
    - name: /usr/src/jool.tar.gz
    - source: {{ jool_download_url }}
    - user: root
    - group: root
    - mode: 700
    - skip_verify: True
  archive.extracted:
    - name: /usr/src/jool-{{ jool_version }}/
    - source: /usr/src/jool.tar.gz
    - user: root
    - group: root
    - enforce_toplevel: False
    - options: --strip-components=1

/usr/src/jool-{{ jool_version }}/dkms.package_version.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        PACKAGE_VERSION={{ jool_version }}
    - require:
      - archive: jool-src

jool-dkms-remove:
  cmd.run:
    - onchanges:
      - archive: jool-src
    - onlyif: test -e /var/lib/dkms/jool/current/
    - require:
      - pkg: jool-build-deps
      - archive: jool-src
      - file: /usr/src/jool-{{ jool_version }}/dkms.package_version.conf
    - name: dkms remove -m jool -v {{ jool_version }} --all

jool-dkms-add:
  cmd.run:
    - onchanges:
      - archive: jool-src
    - require:
      - pkg: jool-build-deps
      - archive: jool-src
      - cmd: jool-dkms-remove
      - file: /usr/src/jool-{{ jool_version }}/dkms.package_version.conf
    - cwd: /usr/local/src/
    - name: dkms add -m jool -v {{ jool_version }}

jool-dkms-build:
  cmd.run:
    - onchanges:
      - cmd: jool-dkms-add
    - cwd: /usr/local/src/
    - name: dkms build -m jool -v {{ jool_version }}

jool-dkms-install:
  cmd.run:
    - onchanges:
      - cmd: jool-dkms-build
    - cwd: /usr/local/src/
    - name: dkms install -m jool -v {{ jool_version }}

jool-userland:
  cmd.run:
    - onchanges:
      - archive: jool-src
    - require:
      - pkg: jool-build-deps
      - archive: jool-src
    - cwd: /usr/src/jool-{{ jool_version }}/
    - name: ./configure && cd src/usr/ && make && make install

jool:
  kmod.present:
    - persist: True
    - require:
      - cmd: jool-dkms-install

/etc/jool:
  file.directory:
    - mode: 644
    - user: root
    - group: root

/etc/systemd/system/jool@.service:
  file.managed:
    - source: salt://jool/files/jool@.service
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: jool-dkms-install

{% for name, instance in salt['pillar.get']('network:nat64:instances', {}).items() %}
/etc/jool/{{ name }}.env:
  file.managed:
    - contents: |
        ARGS= --iptables --pool6 {{ instance['prefix'] }}
        ARGS_POOL4= {{ instance['nat_address'] }} 61001-65535 --max-iterations 1024
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/jool

jool@{{ name }}.service:
  service.running:
    - enable: True
    - restart: True
    - require:
      - file: /etc/systemd/system/jool@.service
      - file: /etc/jool/{{ name }}.env
      - kmod: jool
      - cmd: jool-userland
{% endfor %}

ferm-jool:
  file.line:
    - name: /usr/sbin/ferm
    - content: "add_target_def 'JOOL', qw(instance);"
    - mode: ensure
    - after: "add_target_def 'ULOG'.*"
    - require:
      - pkg: ferm

/etc/ferm/conf.d/jool.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://jool/files/ferm.conf
    - require:
      - file: /etc/ferm/conf.d
      - file: ferm-jool
