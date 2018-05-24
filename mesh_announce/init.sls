install Dependencies for mesh-announce:
  pkg.installed:
    - pkgs:
      - python3-netifaces
      - ethtool
      - lsb-release

get latest mesh-announce:
  git.latest:
    - name: https://github.com/ffnord/mesh-announce
    - target: /opt/mesh-announce
    - force_reset: True


mesh-announce systemd service file:
  file.managed:
    - name: /etc/systemd/system/respondd.service
    - source: salt://mesh_announce/files/respondd.service
    - user: root
    - group: root
    - mode: 644

mesh-announce service:
  service.running:
    - name: respondd
    - enable: True
    - restart: True
    - require:
      - file: /etc/systemd/system/respondd.service
