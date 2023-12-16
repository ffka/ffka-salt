{% set loomio_version = 'v2.21.3' %}

loomio/loomio:{{ loomio_version }}:
  docker_image.present

loomio/loomio_channel_server:latest:
  docker_image.present

loomio:
  user.present:
    - home: /srv/loomio
    - shell: /usr/sbin/nologin

/srv/loomio:
  file.directory:
    - user: loomio
    - dir_mode: '0755'
    - require:
      - user: loomio

loomio_server:
  docker_container.running:
    - image: loomio/loomio:{{ loomio_version }}
    - environment:
      - VIRTUAL_HOST: loomio.vzffnrmo.de
    - binds:
      - /srv/loomio/uploads:/loomio/public/system
      - /srv/loomio/storage:/loomio/storage
      - /srv/loomio/files:/loomio/public/files
      - /srv/loomio/plugins:/loomio/plugins/docker
      - /srv/loomio/import:/import
      - /srv/loomio/tmp:/loomio/tmp
    - restart_policy: always
    - require:
      - docker_image: loomio/loomio:{{ loomio_version }}
      - file: /srv/loomio

loomio_channel_server:
  docker_container.running:
    - image: loomio/loomio_channel_server:latest
    - restart_policy: always
    - require:
      - docker_image: loomio/loomio_channel_server:latest
