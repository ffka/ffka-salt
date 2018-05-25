{% for ffka_user in pillar.get("ffka_users") %}
{{ ffka_user.name }}:
  user.present:
    - shell: /bin/zsh
    - groups:
      - sudo

{% for ssh_key in ffka_user.authorized_keys %}
sshkey {{ ssh_key.key }} for {{ ffka_user.name }}:
  ssh_auth.present:
    - user: {{ ffka_user.name }}
    - enc: {{ ssh_key.enc }}
    - name: {{ ssh_key.key }}
{% endfor %}

/home/{{ ffka_user.name }}/.screenrc:
  file.managed:
    - source: salt://common/files/screenrc.root

{% if ffka_user.get('custom_states', False) %}
{% with %}
{% from 'common/users/' ~ ffka_user.name ~ '.sls' import user_states %}
{{ user_states(ffka_user.name, '/home/' ~ ffka_user.name ~ '/') }}
{% endwith %}
{% endif %}

{% endfor %}
