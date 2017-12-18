add_docker_repo:
  pkgrepo.managed:
    - humanname: Docker CE
    - name: deb [arch=amd64] https://download.docker.com/linux/{{ salt['grains.get']('os')|lower }} {{ salt['grains.get']('oscodename') }} stable
    - dist: {{ salt['grains.get']('oscodename') }}
    - file: /etc/apt/sources.list.d/docker-ce.list
    - gpgcheck: 1
    - key_url: https://download.docker.com/linux/ubuntu/gpg

install_docker_ce:
  pkg.installed:
    - pkgs:
      - docker-ce
    - require:
      - pkgrepo: add_docker_repo

docker_ce_service:
  service.running:
    - name: docker
    - enable: True
    - require:
      - pkg: install_docker_ce