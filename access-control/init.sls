{%- set postgres_version = "12.1-alpine" %}

zutrittskontrolle.git:
  git.latest:
    - name: https://gitlab.karlsruhe.freifunk.net/software/zutrittskontrolle.git
    - target: /usr/src/zutrittskontrolle
    - rev: master

zutrittskontrolle_backend:
  docker_network.present

postgres:{{ postgres_version }}:
  docker_image.present

zutrittskontrolle:
  docker_image.present:
    - build: /usr/src/zutrittskontrolle
    - tag: latest
    - dockerfile: Dockerfile
    - force: True
    - onchanges:
      - git: zutrittskontrolle.git

/var/application-data/zutrittskontrolle:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

zutrittskontrollepg:
  docker_container.running:
    - image: postgres:{{ postgres_version }}
    - environment:
      - POSTGRES_USER: zutrittskontrolle
      - POSTGRES_PASSWORD: ssnxkq6wmivmor5sdbmr
      - POSTGRES_DB: zutrittskontrolle
    - binds:
      - /var/application-data/zutrittskontrolle/database:/var/lib/postgresql/data:rw
    - restart_policy: always
    - network_mode: zutrittskontrolle_backend
    - require:
      - docker_network: zutrittskontrolle_backend
      - docker_image: postgres:{{ postgres_version }}
      - file: /var/application-data/zutrittskontrolle

zutrittskontrolle_server:
  docker_container.running:
    - image: zutrittskontrolle:latest
    - environment:
      - ALLOWED_HOSTS: "*"
      - DB_USER: zutrittskontrolle
      - DB_PASSWORD: ssnxkq6wmivmor5sdbmr
      - DB_NAME: zutrittskontrolle
      - DB_HOST: zutrittskontrollepg
    - network_mode: zutrittskontrolle_backend
    - port_bindings:
      - "8000:8000"
    - restart_policy: always
    - command: python3 -u manage.py runserver [::]:8000
    - require:
      - docker_network: zutrittskontrolle_backend
    - watch:
      - docker_image: zutrittskontrolle

zutrittskontrolle_importer:
  docker_container.running:
    - image: zutrittskontrolle:latest
    - environment:
      - DB_USER: zutrittskontrolle
      - DB_PASSWORD: ssnxkq6wmivmor5sdbmr
      - DB_NAME: zutrittskontrolle
      - DB_HOST: zutrittskontrollepg
    - network_mode: zutrittskontrolle_backend
    - restart_policy: always
    - command: python3 -u manage.py runimport ffka 'https://api.karlsruhe.freifunk.net/yanic/meshviewer/nodes.json'
    - require:
      - docker_network: zutrittskontrolle_backend
    - watch:
      - docker_image: zutrittskontrolle
