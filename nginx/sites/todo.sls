{% macro custom_states(name, vhost, domainset) -%}

wekan:
  docker_image.present:
    - names:
      - mongo:3.2.20
      - quay.io/wekan/wekan
  docker_network.present:
    - name: wekan

wekan-db:
  docker_container.running:
    - image: mongo:3.2.20
    - name: wekan-db
    - command: "mongod --smallfiles --oplogSize 128"
    - ports: 27017
    - binds:
      - /srv/www/todo/mongodb_data:/data/db
      - /srv/www/todo/mongodb_dump:/dump
    - networks: wekan
    - restart_policy: always
    - require:
      - docker_image: wekan
      - docker_network: wekan

wekan-app:
  docker_container.running:
    - image: quay.io/wekan/wekan
    - name: wekan-app
    - networks: wekan
    - restart_policy: always
    - port_bindings:
      - 127.0.0.1:8088:80
    - environment:
      - ROOT_URL: "https://todo.ffka.vzffnrmo.de"
      - MONGO_URL: "mongodb://wekan-db:27017/wekan"
    - require:
      - docker_image: wekan
      - docker_network: wekan
      - docker_container: wekan-db

{%- endmacro %}
