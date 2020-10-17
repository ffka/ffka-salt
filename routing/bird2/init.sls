/etc/apt/preferences.d/bird2:
  file.managed:
    - contents: |
        Package: bird2
        Pin: release n=unstable
        Pin-Priority: 800

bird:
  pkg.purged

/etc/bird2:
  file.absent

bird2:
  pkg.installed:
    - require:
      - file: /etc/bird2
      - file: /etc/apt/preferences.d/bird2
      - pkgrepo: unstable
      - pkg: bird

/etc/bird/bird.d/:
  file.directory:
    - mode: '0755'
    - user: bird
    - group: bird
    - makedirs: True
    - require:
      - pkg: bird2

bird.service:
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: bird2
    - watch:
      - /etc/bird/bird.conf
      - /etc/bird/bird.d/*

/etc/bird/bird.conf:
  file.managed:
    - contents: |
        protocol device {
          scan time 10;
        }
        include "bird.d/*.conf";
    - user: bird
    - group: bird
    - mode: '0664'
    - require:
      - pkg: bird2

include:
  - common.debian_unstable
