docker-repo:
  pkgrepo.managed:
    - humanname: Docker CE
    - name: deb [arch=amd64] https://download.docker.com/linux/{{ salt['grains.get']('os')|lower }} {{ salt['grains.get']('oscodename') }} stable
    - dist: {{ salt['grains.get']('oscodename') }}
    - file: /etc/apt/sources.list.d/docker-ce.list
    - gpgcheck: 1
    - key_url: https://download.docker.com/linux/ubuntu/gpg

docker-ce:
  pkg.installed:
    - require:
      - pkgrepo: docker-repo

/etc/docker/daemon.json:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - content: |
        {
          "ipv6": true,
          "fixed-cidr-v6": "fd00::/64"
        }
    - require:
      - pkg: docker-ce

docker.service:
  service.running:
    - enable: True
    - require:
      - pkg: docker-ce
      - file: /etc/docker/daemon.json

python-docker:
  pkg.installed:
    - require:
      - pkg: docker-ce
