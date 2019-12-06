{% macro user_states(username, home) -%}

{% for key, type in [
  ('AAAAB3NzaC1yc2EAAAADAQABAAABAQDeXDrG2yRE9XQlzMCa9YvkotiARI9wTGdhxlg50pYqUd0Jy7NlAVAHuYIoXz8E6KEZy9SZhzRs05hiRZHgUl3Dh8BeVtYD8TwKaMuUFQeqasOoQY94f25d4mwawycNHdoPvbfxwhvxXbRweLSpaGktyNhL4+0X18v04VOAFUuM5xUVTvo3petpURi28Wm/mACK66VBmd7dCPt5Xt5PLelBZJhf2Fz5sHpdcObsTVS5GWl7J/JM+8AxVV1QuZUtORET2qQvqXb79wu2u4aC+3S67WQXYf9h1RhOciDqca1KtoGYH3FNQ3qnbz9jdk6rsF8e4e5PAos7EgMcWAS3I+qH', 'ssh-rsa'),
  ('AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBMoiX3FLxpvK+txr/ax4OLIm1bSemyKr5K3ZV7eI8/P4CIv4EQwBtnTfI/zAbWbqYtoQ92YqYQwpxRdpmsccKeg=', 'ecdsa-sha2-nistp256'),
  ('AAAAC3NzaC1lZDI1NTE5AAAAIPIuK8H/N2b1rT8iYRM3j4huK+s+wmf1kJIztEncbjxK', 'ssh-ed25519')] %}
julez.dev-{{ type }}:
  ssh_known_hosts:
    - present
    - name: julez.dev
    - user: julez
    - enc: {{ type }}
    - key: {{ key }}
    - require_in:
      - git: julez_dotfiles
{% endfor %}

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