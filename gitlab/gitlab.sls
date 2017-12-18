install_gitlab_repo_dependencies:
  pkg.installed:
    - pkgs:
      - curl
      - openssh-server
      - ca-certificates

add_gitlab_repo:
  pkgrepo.managed:
    - humanname: Gitlab
    - name: deb https://packages.gitlab.com/gitlab/gitlab-ce/ubuntu/ xenial main
    - dist: xenial
    - file: /etc/apt/sources.list.d/gitlab_gitlab-ce.list
    - gpgcheck: 1
    - key_url: https://packages.gitlab.com/gitlab/gitlab-ee/gpgkey

install_gitlab:
  pkg.installed:
    - pkgs:
      - gitlab-ce
    - require:
      - pkgrepo: add_gitlab_repo

deploy_config:
  file.managed:
    - name: /etc/gitlab/gitlab.rb
    - source: salt://gitlab/files/gitlab.rb.j2
    - template: jinja
    - require:
      - pkg: install_gitlab

reconfigure_gitlab:
  cmd.run:
    - name: gitlab-ctl reconfigure
    - onchanges:
      - file: deploy_config

gitlab-ce-service:
  service.running:
    - name: gitlab-runsvdir
    - enable: True
    - require:
      - pkg: install_gitlab
      - cmd: reconfigure_gitlab
