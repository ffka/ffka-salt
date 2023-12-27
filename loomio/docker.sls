{% set loomio_version = 'v2.21.3' %}

loomio/loomio:{{ loomio_version }}:
  docker_image.present

loomio/loomio_channel_server:latest:
  docker_image.present

redis:7:
  docker_image.present

loomio_network:
  docker_network.present

loomio:
  user.present:
    - home: /srv/loomio
    - shell: /usr/sbin/nologin
    - system: True
    - uid: 4001

/srv/loomio:
  file.directory:
    - user: loomio
    - dir_mode: '0755'
    - require:
      - user: loomio

loomio_server:
  docker_container.running:
    - image: loomio/loomio:{{ loomio_version }}
    - user: 4001
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
    - network_mode: loomio_network
    - require:
      - docker_image: loomio/loomio:{{ loomio_version }}
      - docker_network: loomio_network
      - file: /srv/loomio
      - user: loomio

loomio_channel_server:
  docker_container.running:
    - image: loomio/loomio_channel_server:latest
    - user: 4001
    - restart_policy: always
    - network_mode: loomio_network
    - require:
      - docker_image: loomio/loomio_channel_server:latest
      - docker_network: loomio_network
      - user: loomio

loomio_redis:
  docker_container.running:
    - image: redis:7
    - user: 4001
    - restart_policy: always
    - network_mode: loomio_network
    - require:
      - docker_image: redis:7
      - docker_network: loomio_network
      - user: loomio