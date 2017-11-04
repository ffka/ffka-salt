{% for ffka_user in pillar.get("ffka_users") %}
{{ ffka_user.name }}:
  user.present:
    - shell: /bin/zsh
    - groups:
      - sudo

/home/{{ ffka_user.name }}/.ssh/authorized_keys:
  file.managed:
    - source: salt://common/files/authorized_keys.tpl
    - user: {{ ffka_user.name }}
    - group: {{ ffka_user.name }}
    - mode: 600
    - makedirs: True
    - template: jinja

/home/ffkaadmin/.screenrc:
  file.managed:
    - source: salt://common/files/screenrc.root
{% endfor %}
