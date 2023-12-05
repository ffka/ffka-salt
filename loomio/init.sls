{% set loomio_version = 'v2.21.3' %}

loomio/loomio:{{ loomio_version  }}:
  docker_image.present

loomio/loomio_channel_server:latest:
  docker_image.present


