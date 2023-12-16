{% set loomio_version = 'v2.21.3' %}

loomio/loomio:{{ loomio_version }}:
  docker_image.present

loomio/loomio_channel_server:latest:
  docker_image.present

loomio_server:
    docker_container.running:
      - image: loomio/loomio:{{ loomio_version }}
      - restart_policy: always
      - require:
        - docker_image: loomio/loomio:{{ loomio_version }}

loomio_channel_server:
    docker_container.running:
      - image: loomio/loomio_channel_server:latest
      - restart_policy: always
      - require:
        - docker_image: loomio/loomio_channel_server:latest
