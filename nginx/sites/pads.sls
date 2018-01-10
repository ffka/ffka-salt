{%- set hackmd_version = "0.5.1" -%}
{%- set hackmd_postgres_version = "9.6-alpine" -%}

/srv/www/pads/database:
  file.directory:
    - require:
      - test: nginx_pads

hackmd_backend:
  docker_network.present

images:
  docker_image.present:
    - names:
      - postgres:{{ hackmd_postgres_version }}
      - hackmdio/hackmd:{{ hackmd_version }}

hackmdpostgres:
  docker_container.running:
    - image: postgres:{{ hackmd_postgres_version }}
    - environment:
      - POSTGRES_USER: hackmd
      - POSTGRES_PASSWORD: hackmdpass
      - POSTGRES_DB: hackmd
    - binds:
      - /srv/www/pads/database:/var/lib/postgresql/data:rw
    - network_mode: hackmd_backend
    - require:
      - docker_network: hackmd_backend
      - docker_image: postgres:{{ hackmd_postgres_version }}
      - file: /srv/www/pads/database

hackmdapp:
  docker_container.running:
    - image: hackmdio/hackmd:{{ hackmd_version }}
    - environment:
      - HMD_DB_URL=postgres://hackmd:hackmdpass@hackmdpostgres:5432/hackmd
      {%- for setting, value in salt['pillar.get']('hackmd:settings', {}).items() %}
      - {{ setting }}={{ value }}
      {% endfor %}
    - network_mode: hackmd_backend
    - port_bindings:
      - 127.0.0.1:3000:3000
    - restart_policy: always
    - require:
      - docker_network: hackmd_backend
      - docker_image: postgres:{{ hackmd_postgres_version }}
      - file: /srv/www/pads/database