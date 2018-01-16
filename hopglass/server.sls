hopglass:
  user.present

hopglass-server.git:
  git.latest:
    - name: https://github.com/hopglass/hopglass-server.git
    - target: /home/hopglass/server.git
    - user: hopglass
    - branch: v0.1.3
    - force_fetch: True
    - force_reset: True
    - require:
      - user: hopglass

/home/hopglass/server.git:
  npm.bootstrap:
    - user: hopglass
    - silent: False
    - require:
      - git: hopglass
      - user: hopglass