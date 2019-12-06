{% macro user_states(username, home) -%}

julez_packages:
  pkg.installed:
    - pkgs:
      - stow
      - git

julez_dotfiles:
  git.latest:
    - name: https://julez.dev/stuff/dotfiles
    - target: {{ home }}/.dotfiles
    - branch: master
    - user: {{ username }}
    - submodules: True
    - force_reset: True
  require:
    - pkg: julez_packages

update dotfiles:
  cmd.run:
    - name: {{ home }}/.dotfiles/update.sh do_update
    - runas: {{ username }}
    - onchanges:
      - git: julez_dotfiles
    - require:
      - pkg: julez_packages
    - env:
      - HOME: {{ home }}

{%- endmacro %}