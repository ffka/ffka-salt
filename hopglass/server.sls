{%- set hopglass_server_version = "v0.1.3" -%}

hopglass:
  user.present

hopglass-server.git:
  git.latest:
    - name: https://github.com/hopglass/hopglass-server.git
    - target: /home/hopglass/server.git
    - user: hopglass
    - rev: {{ hopglass_server_version }}
    - force_fetch: True
    - force_reset: True
    - require:
      - user: hopglass

/home/hopglass/server.git:
  npm.bootstrap:
    - user: hopglass
    - silent: False
    - require:
      - git: hopglass-server.git
      - user: hopglass