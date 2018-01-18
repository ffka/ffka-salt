{% macro custom_states(name, vhost, domainset) -%}

{%- set netbox_version = "v2.2.8" -%}
{%- set netbox_postgres_version = "9.6-alpine" -%}

{% for dir in ["database", "media", "reports"] %}
/srv/www/netbox/{{ dir }}:
  file.directory:
    - require:
      - test: nginx_netbox
    - require_in:
      - docker_container: netboxpostgres
      - docker_container: netbox
{% endfor %}

# This does not _yet_ work, as IPv6 must be enabled. Will work with the next salt release.
# Until then: docker network create --ipv6 --subnet fd00:1::/64 netbox_backend
# ip6tables -t nat -A POSTROUTING -s fd00:1::/64 -j MASQUERADE (Yes - please don't beat me up, it's the easiest solution for outgoing IPv6 connectivity right now :/)
netbox_backend:
  docker_network.present

images:
  docker_image.present:
    - names:
      - postgres:{{ netbox_postgres_version }}
      - ninech/netbox:{{ netbox_version }}

netboxpostgres:
  docker_container.running:
    - image: postgres:{{ netbox_postgres_version }}
    - environment:
      - POSTGRES_USER: netbox
      - POSTGRES_PASSWORD: MFcdVTzvghvdSIlFE
      - POSTGRES_DB: netbox
    - binds:
      - /srv/www/netbox/database:/var/lib/postgresql/data:rw
    - restart_policy: always
    - network_mode: netbox_backend
    - require:
      - docker_network: netbox_backend
      - docker_image: postgres:{{ netbox_postgres_version }}

netbox:
  docker_container.running:
    - image: ninech/netbox:{{ netbox_version }}
    - environment:
      - ALLOWED_HOSTS=localhost 0.0.0.0 127.0.0.1 [::1] netbox
      - DB_NAME=netbox
      - DB_USER=netbox
      - DB_PASSWORD=MFcdVTzvghvdSIlFE
      - DB_HOST=netboxpostgres
      - EMAIL_SERVER=localhost
      - EMAIL_PORT=25
      - EMAIL_USERNAME=netbox
      - EMAIL_PASSWORD=
      - EMAIL_TIMEOUT=5
      - EMAIL_FROM=netbox@bar.com
      - NAPALM_TIMEOUT=5
      - MAX_PAGE_SIZE=0
      - SECRET_KEY=SAzlNxGh5StmbIwQHRGtTvF
      - SUPERUSER_NAME=admin
      - SUPERUSER_EMAIL=admin@example.com
      - SUPERUSER_PASSWORD=SAzlNxGh5StmbIwQHRGtTvF
      - SUPERUSER_API_TOKEN=SAzlNxGh5StmbIwQHRGtTvFSAzlNxGh5StmbIwQHRGtTvF
    - network_mode: netbox_backend
    - port_bindings:
      - 127.0.0.1:8001:8001
    - restart_policy: always
    - binds:
      - /srv/www/netbox/database:/var/lib/postgresql/data:rw
      - /srv/www/netbox/htdocs:/opt/netbox/netbox/static:rw
      - /srv/www/netbox/media:/opt/netbox/netbox/media:rw
      - /srv/www/netbox/reports:/opt/netbox/netbox/reports:rw
    - require:
      - docker_network: netbox_backend
      - docker_image: postgres:{{ netbox_postgres_version }}

{%- endmacro %}
