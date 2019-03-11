mesh-announce dependencies:
  pkg.installed:
    - pkgs:
      - ethtool
      - lsb-release
      - python3-netifaces

mesh-announce:
  git.latest:
    - name: https://github.com/freifunk-darmstadt/mesh-announce.git
    - target: /opt/mesh-announce
    - force_reset: True

/etc/mesh-announce:
  file.directory:
    - mode: 755

/etc/systemd/system/mesh-announce@.service:
  file.managed:
    - source: salt://mesh-announce/files/mesh-announce@.service
    - user: root
    - group: root
    - mode: 644
