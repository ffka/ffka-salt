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

jool:
  kmod.present:
    - persist: True
    - require:
      - cmd: jool-dkms

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
      - cmd: jool-dkms

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
      - cmd: jool-tools
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
