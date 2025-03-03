{% macro custom_states(name, vhost, domainset) -%}

{%- set hackmd_version = "1.9.9-debian" -%}
{%- set hackmd_postgres_version = "9.6-alpine" -%}

/srv/www/pads/database:
  file.directory:
    - require:
      - test: nginx_pads

# This does not _yet_ work, as IPv6 must be enabled. Will work with the next salt release.
# Until then: docker network create --ipv6 --subnet fd00:1::/64 hackmd_backend
# ip6tables -t nat -A POSTROUTING -s fd00:1::/64 -j MASQUERADE (Yes - please don't beat me up, it's the easiest solution for outgoing IPv6 connectivity right now :/)
hackmd_backend:
  docker_network.present

images:
  docker_image.present:
    - names:
      - postgres:{{ hackmd_postgres_version }}
      - quay.io/hedgedoc/hedgedoc:{{ hackmd_version }}

hackmdpostgres:
  docker_container.running:
    - image: postgres:{{ hackmd_postgres_version }}
    - environment:
      - POSTGRES_USER: hackmd
      - POSTGRES_PASSWORD: hackmdpass
      - POSTGRES_DB: hackmd
    - binds:
      - /srv/www/pads/database:/var/lib/postgresql/data:rw
    - restart_policy: always
    - network_mode: hackmd_backend
    - require:
      - docker_network: hackmd_backend
      - docker_image: postgres:{{ hackmd_postgres_version }}
      - file: /srv/www/pads/database

hackmdapp:
  docker_container.running:
    - image: quay.io/hedgedoc/hedgedoc:{{ hackmd_version }}
    - environment:
      - CMD_DB_URL=postgres://hackmd:hackmdpass@hackmdpostgres:5432/hackmd
      - CMD_DOMAIN={{ domainset[0] }}
      - CMD_PROTOCOL_USESSL=true
      - CMD_URL_ADDPORT=false
      - CMD_USECDN=false
      - CMD_ALLOW_ORIGIN={{ domainset|join(', ') }}
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

{%- endmacro %}
