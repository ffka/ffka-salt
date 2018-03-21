install_gitlab_repo_dependencies:
  pkg.installed:
    - pkgs:
      - curl
      - openssh-server
      - ca-certificates

packages.gitlab.com:
  pkgrepo.managed:
    - humanname: Gitlab
    - name: deb https://packages.gitlab.com/gitlab/gitlab-ce/{{ grains.os | lower }}/ {{ grains.oscodename }} main
    - dist: {{ grains.oscodename }}
    - file: /etc/apt/sources.list.d/gitlab_gitlab-ce.list
    - gpgcheck: 1
    - key_url: https://packages.gitlab.com/gitlab/gitlab-ce/gpgkey

gitlab-ce:
  pkg.installed:
    - pkgs:
      - gitlab-ce
    - require:
      - pkgrepo: packages.gitlab.com

gitlab.rb:
  file.managed:
    - name: /etc/gitlab/gitlab.rb
    - source: salt://gitlab/files/gitlab.rb.j2
    - template: jinja
    - require:
      - pkg: gitlab-ce

reconfigure:
  cmd.run:
    - name: gitlab-ctl reconfigure
    - onchanges:
      - file: gitlab.rb
    - require:
      - pkg: gitlab-ce

gitlab-ce-service:
  service.running:
    - name: gitlab-runsvdir
    - enable: True
    - require:
      - pkg: gitlab-ce
      - cmd: reconfigure
