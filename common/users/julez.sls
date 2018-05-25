{% macro user_states(username, home) -%}

julez_packages:
  pkg.installed:
    - pkgs:
      - stow
      - git

julez_dotfiles:
  git.latest:
    - name: https://git.home.julez.io/stuff/dotfiles
    - target: {{ home }}/.dotfiles
    - branch: master
    - user: {{ username }}
    - submodules: True
  require:
    - pkg: julez_packages

update dotfiles:
  cmd.run:
    - name: {{ home }}/.dotfiles/update.sh do_update
    - user: {{ username }}
    - onchanges:
      - git: julez_dotfiles
    - require:
      - pkg: julez_packages

{%- endmacro %}