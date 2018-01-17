install Dependencies for mesh-announce:
  pkg.installed:
    - pkgs:
      - python3-netifaces
      - ethtool
      - lsb-release

get latest mesh-announce:
  git.latest:
    - name: https://github.com/ffnord/mesh-announce
    - target: /opt/ext-respondd
    - force_clone: True


mesh-announce systemd service file:
  file.managed:
    - name: /etc/systemd/system/respondd.service
    - source: salt://respondd/files/respondd.service
    - user: root
    - group: root
    - mode: 644

mesh-announce service:
  service.running:
    - name: ext-respondd
    - enable: True
    - require:
      - file: /lib/systemd/system/respondd.service
