{% macro user_states(name, home) -%}

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
    - user: {{ name }}
    - submodules: True
  require:
    - pkg: julez_packages

update dotfiles:
  cmd.run:
    - name: {{ home }}/.dotfiles/update.sh do_update
    - user: {{ name }}
    - onchanges:
      - git: julez_dotfiles
    - require:
      - pkg: julez_packages

{%- endmacro %}