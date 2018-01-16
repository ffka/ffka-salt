nodejs:
  pkgrepo.managed:
    - humanname: nodejs
    - name: deb https://deb.nodesource.com/node_8.x stretch main
    - key_url: salt://apt/files/keys/nodejs.gpg
    - file: /etc/apt/sources.list.d/nodejs.list
  pkg.latest:
    - pkgs:
      - nodejs
    - require:
      - pkgrepo: nodejs