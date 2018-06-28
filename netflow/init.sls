# This state installs ipt-netflow, the netflow iptables module, from source.
# We use a dummy version 'current' so the directories are more predictable
# and automation is easier. The version will always be replaced by a newer version.

netflow-ipt-build-deps:
  pkg.installed:
    - pkgs:
      - build-essential
      - git
      - dkms
      - linux-headers-{{ grains.kernelrelease }}
      - pkg-config
      - module-assistant
      - libxtables-dev

netflow-ipt-src:
  git.latest:
    - name: https://github.com/aabc/ipt-netflow.git
    - target: /usr/src/ipt-netflow
    - rev: master
    - require:
      - pkg: netflow-ipt-build-deps

netflow-ipt-dkms-configure:
  cmd.run:
    - name: ./configure
    - cwd: /usr/src/ipt-netflow
    - onchanges:
      - git: netflow-ipt-src
    - require:
      - pkg: netflow-ipt-build-deps
      - git: netflow-ipt-src

netflow-ipt-dkms-make:
  cmd.run:
    - name: make all install
    - cwd: /usr/src/ipt-netflow
    - onchanges:
      - cmd: netflow-ipt-dkms-configure

/etc/modprobe.d/ipt_NETFLOW.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        options ipt_NETFLOW destination=127.0.0.1:2055 protocol=10
    - require:
      - git: netflow-ipt-src

ipt_NETFLOW:
  kmod.present:
    - persist: True
    - require:
      - file: /etc/modprobe.d/ipt_NETFLOW.conf
      - cmd: netflow-ipt-dkms-configure
      - cmd: netflow-ipt-dkms-make