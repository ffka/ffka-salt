zutrittskontrolle.git:
  git.latest:
    - name: https://gitlab.karlsruhe.freifunk.net/software/zutrittskontrolle.git
    - target: /usr/src/zutrittskontrolle
    - rev: master

zutrittskontrolle_backend:
  docker_network.present

postgres:12.1-alpine:
  docker_image.present

zutrittskontrolle:
  docker_image.present:
    - build: /usr/src/zutrittskontrolle
    - tag: latest
    - dockerfile: Dockerfile
    - require:
      - git: zutrittskontrolle.git

