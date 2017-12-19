gitlab-runner-repo-deps:
  pkg.installed:
    - pkgs:
      - curl
      - ca-certificates
      - apt-transport-https
      - software-properties-common

gitlab-runner-repo:
  pkgrepo.managed:
    - humanname: Gitlab Runner
    - name: deb https://packages.gitlab.com/runner/gitlab-runner/{{ salt['grains.get']('os')|lower }}/ {{ salt['grains.get']('oscodename') }} main
    - dist: {{ salt['grains.get']('oscodename') }}
    - file: /etc/apt/sources.list.d/runner_gitlab-runner.list
    - gpgcheck: 1
    - key_url: https://packages.gitlab.com/gitlab/gitlab-ce/gpgkey
    - require:
      - pkg: gitlab-runner-repo-deps

gitlab-runner:
  pkg.installed:
    - require:
      - pkgrepo: gitlab-runner-repo

gitlab-runner.service:
  service.running:
    - enable: True
    - require:
      - pkg: gitlab-runner


gitlab-runner-registration:
  cmd.run:
    - name: |
        gitlab-runner unregister --all-runners
{% for proj in salt['pillar.get']('gitlab:runners', []) %}
        gitlab-runner register --non-interactive --url {{ proj['gitlab_url'] }} --run-untagged --tag-list "{{ proj['tag_list'] }}" --executor docker --docker-image dind --registration-token {{ proj['token'] }} --name {{ proj['name'] }} --docker-privileged
{% endfor %}
    - require:
      - service: gitlab-runner.service

gitlab-runner-output-limit:
  file.line:
    - name: /etc/gitlab-runner/config.toml
    - mode: ensure
    - after: |
        \[\[runners\]\]
    - indent: False
    - content: "  output_limit = 102400"
    - require:
      - cmd: gitlab-runner-registration
