{% set loomio_version = 'v2.21.4' %}

{% set loomio_env = salt['pillar.get']('loomio:env', []) %}

loomio/loomio:{{ loomio_version }}:
  docker_image.present

loomio/loomio_channel_server:latest:
  docker_image.present

loomio/mailin-docker:latest:
  docker_image.present

redis:7:
  docker_image.present

postgres:16:
  docker_image.present

loomio_network:
  docker_network.present

loomio:
  group.present:
    - gid: 4001
    - system: True
  user.present:
    - home: /srv/loomio
    - shell: /usr/sbin/nologin
    - system: True
    - uid: 4001
    - gid: 4001

/srv/loomio:
  file.directory:
    - user: loomio
    - group: loomio
    - dir_mode: '0755'
    - require:
      - user: loomio
      - group: loomio

loomio-server:
  docker_container.running:
    - image: loomio/loomio:{{ loomio_version }}
    - user: 4001
    - group: 4001
    - environment: {{ loomio_env | yaml }}
    - binds:
      - /srv/loomio/uploads:/loomio/public/system
      - /srv/loomio/storage:/loomio/storage
      - /srv/loomio/files:/loomio/public/files
      - /srv/loomio/plugins:/loomio/plugins/docker
      - /srv/loomio/import:/import
      - /srv/loomio/tmp:/loomio/tmp
    - restart_policy: always
    - port_bindings:
      - 127.0.0.1:3000:3000
    - networks:
      - loomio_network
    - require:
      - docker_image: loomio/loomio:{{ loomio_version }}
      - docker_network: loomio_network
      - file: /srv/loomio
      - user: loomio

loomio-channel-server:
  docker_container.running:
    - image: loomio/loomio_channel_server:latest
    - user: 4001
    - group: 4001
    - environment: {{ loomio_env | yaml }}
    - restart_policy: always
    - port_bindings:
      - 127.0.0.1:3001:5000
    - networks:
      - loomio_network
    - require:
      - docker_image: loomio/loomio_channel_server:latest
      - docker_network: loomio_network
      - user: loomio

loomio-redis:
  docker_container.running:
    - image: redis:7
    - user: 4001
    - group: 4001
    - environment: {{ loomio_env | yaml }}
    - binds:
      - /srv/loomio/redis:/data
    - restart_policy: always
    - networks:
      - loomio_network
    - require:
      - docker_image: redis:7
      - docker_network: loomio_network
      - user: loomio

loomio-postgres:
  docker_container.running:
    - image: postgres:16
    - environment: {{ loomio_env | yaml }}
    - binds:
      - /srv/loomio/pgdata:/var/lib/postgresql/data
    - restart_policy: always
    - networks:
      - loomio_network
    - require:
      - docker_image: postgres:16
      - docker_network: loomio_network

loomio-mailin:
  docker_container.running:
    - image: loomio/mailin-docker:latest
    - environment:
      - WEBHOOK_URL: http://loomio-server:3000/email_processor/
    - restart_policy: always
    - networks:
      - loomio_network
    - port_bindings:
      - 0.0.0.0:25:25
    - require:
      - docker_image: loomio/mailin-docker:latest
      - docker_network: loomio_network
