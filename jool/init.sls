include:
  - common.debian_unstable

/etc/apt/preferences.d/jool-unstable:
  file.managed:
    - contents: |
        Package: jool-*
        Pin: release n=unstable
        Pin-Priority: 800

jool-deps:
  pkg.installed:
    - pkgs:
      - dkms
      - linux-headers-{{ grains.kernelrelease }}

jool-dkms:
  pkg.installed:
    - fromrepo: unstable
    - require:
      - pkgrepo: unstable
      - file: /etc/apt/preferences.d/jool-unstable

jool-tools:
  pkg.installed:
    - fromrepo: unstable
    - require:
      - pkgrepo: unstable
      - file: /etc/apt/preferences.d/jool-unstable

/etc/jool:
  file.directory:
    - mode: 644
    - user: root
    - group: root

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
