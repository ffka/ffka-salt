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
    - require:
      - git: zutrittskontrolle.git

/var/application-data/zutrittskontrolle:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

zutrittskontrolle_postgres:
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

