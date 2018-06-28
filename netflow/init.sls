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

netflow-ipt-dkms:
  cmd.run:
    - name: |
      ./install-dkms.sh --install
      MVERSION=$(./version.sh)
      dkms build -m ipt-netflow -v ${MVERSION}
      dkms install -m ipt-netflow -v ${MVERSION}
    - cwd: /usr/src/ipt-netflow
    - onchanges:
      - git: netflow-ipt-src
    - require:
      - pkg: netflow-ipt-build-deps
      - git: netflow-ipt-src
