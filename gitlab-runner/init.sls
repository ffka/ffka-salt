install_gitlab_repo_dependencies:
  pkg.installed:
    - pkgs:
      - curl
      - ca-certificates
      - apt-transport-https
      - software-properties-common

add_gitlab_runner_repo:
  pkgrepo.managed:
    - humanname: Gitlab Runner
    - name: deb https://packages.gitlab.com/runner/gitlab-runner/{{ salt['grains.get']('os')|lower }}/ {{ salt['grains.get']('oscodename') }} main
    - dist: {{ salt['grains.get']('oscodename') }}
    - file: /etc/apt/sources.list.d/runner_gitlab-runner.list
    - gpgcheck: 1
    - key_url: https://packages.gitlab.com/gitlab/gitlab-ce/gpgkey

install_gitlab_runner:
  pkg.installed:
    - pkgs:
      - gitlab-runner
    - require:
      - pkgrepo: add_gitlab_runner_repo

gitlab_runner_service:
  service.running:
    - name: gitlab-runner
    - enable: True
    - require:
      - pkg: install_gitlab_runner

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

gitlab_runner_registration:
  cmd.run:
    - name: |
        gitlab-runner unregister --all-runners
{% for proj in pillar['gitlab_runners'] %}
        gitlab-runner register --non-interactive --run-untagged --tag-list {{ proj['tag_list'] }} --url {{ pillar['gitlab_url'] }} --executor docker --docker-image dind --registration-token {{ proj['token'] }} --name {{ proj['name'] }}
{% endfor %}
    - require:
      - service: gitlab_runner_service

enable_priviledged:
  file:
    - replace
    - name: /etc/gitlab-runner/config.toml
    - pattern: 'privileged = false'
    - repl: 'privileged = true'
    - require:
      - cmd: gitlab_runner_registration