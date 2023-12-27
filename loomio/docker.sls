{% set loomio_version = 'v2.21.3' %}

{% set loomio_env = {
  'VIRTUAL_HOST': 'loomio.vzffnrmo.de',
  'CHANNELS_URI': 'wss://channels.loomio.vzffnrmo.de',
  'RAILS_ENV': 'production',
  'POSTGRES_DB': 'loomio_db',
  'REDIS_URL': 'redis://loomio_redis:6379/0'
}
%}

{% set loomio_env_list = [] %}

{% for key, value in loomio_env.items() %}
  {% loomio_env_list.append(f"{key}: {value}" %}
{% endfor %}

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
    - environment: {{ loomio_env_list | yaml }}
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
    - environment: {{ loomio_env_list | yaml }}
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
    - environment: {{ loomio_env_list | yaml }}
    - restart_policy: always
    - network_mode: loomio_network
    - require:
      - docker_image: redis:7
      - docker_network: loomio_network
      - user: loomio