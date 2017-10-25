ffkaadmin:
  user.present:
    - shell: /bin/zsh
    - groups:
      - sudo



/home/ffkaadmin/.ssh/authorized_keys:
  file.managed:
    - source: salt://common/files/authorized_keys.tpl
    - user: ffkaadmin
    - group: ffkaadmin
    - mode: 600
    - makedirs: True
    - template: jinja

/home/ffkaadmin/.screenrc:
  file.managed:
    - source: salt://common/files/screenrc.root
