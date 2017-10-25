sudo:
  pkg.installed

/etc/sudoers.d/ops:
  file.managed:
    - user: root
    - group: root
    - mode: 440
    - contents: "%ops ALL=(ALL:ALL) NOPASSWD: ALL"

/etc/sudoers:
  file.managed:
    - user: root
    - group: root
    - mode: 440
    - source: salt://common/files/sudoers
