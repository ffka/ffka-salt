# This state installs jool from source.
# We use a dummy version 'current' so the directories are more predictable
# and automation is easier. The version will always be replaced by a newer version.

{% set jool_version = 'current' %}
{% set jool_download_url = 'https://github.com/NICMx/Jool/releases/download/v4.0.0/jool_4.0.0.tar.gz' %}

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

jool:
  kmod.present:
    - persist: True
    - require:
      - cmd: jool-dkms-install

jool-userland:
  cmd.run:
    - onchanges:
      - archive: jool-src
    - require:
      - pkg: jool-build-deps
      - archive: jool-src
    - cwd: /usr/src/jool-{{ jool_version }}/
    - name: ./configure && cd src/usr/ && make && make install

/etc/ferm/conf.d/jool.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        domain ip6 table mangle chain PREROUTING {
          daddr 64:ff9b::/96 JOOL instance default;
        }
        domain ip table mangle chain PREROUTING {
          proto tcp daddr 185.65.241.64 dport 61001:65535 JOOL instance default;
          proto udp daddr 185.65.241.64 dport 61001:65535 JOOL instance default;
          proto icmp daddr 185.65.241.64 JOOL instance default;
        }
    - require:
      - file: /etc/ferm/conf.d
