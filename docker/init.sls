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
    - mode: '0644'
    - contents: |
        {
          "ipv6": true,
          "fixed-cidr-v6": "fd00::/64"
        }
    - require:
      - pkg: docker-ce

/etc/ferm/conf.d/docker.conf:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        @def $DOCKER_INTERNAL_NETS = (fd00::/64 fd00:1::/64 fd00:2::/64);
        domain ip6 table nat chain POSTROUTING {
            saddr $DOCKER_INTERNAL_NETS MASQUERADE;
        }
    - require:
      - file: /etc/ferm/conf.d

docker.service:
  service.running:
    - enable: True
    - require:
      - pkg: docker-ce
    - watch:
      - file: /etc/docker/*

python-docker:
  pip.installed:
    - name: docker
    - upgrade: True
    - require:
      - pkg: docker-ce

