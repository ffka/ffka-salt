tor_repo:
  pkgrepo.managed:
    - humanname: torproject
    - name: deb https://deb.torproject.org/torproject.org {{ salt['grains.get']('oscodename') }} main
    - file: /etc/apt/sources.list.d/torproject.list

install tor:
  pkg.installed:
    - name: tor deb.torproject.org-keyring

service tor:
  service.running:
    - name: tor
    - enable: True
    - reload: True
    - require:
      - file: /etc/tor/torrc

place /etc/tor/torrc:
  file.managed:
    - name: /etc/tor/torrc
    - source: salt://torrelay/files/torrc
    - user: root
    - group: root
    - mode: '0644'