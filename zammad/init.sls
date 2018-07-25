zammad-repo:
  pkgrepo.managed:
    - humanname: Zammad
    - name: deb https://dl.packager.io/srv/deb/zammad/zammad/stable/{{ salt['grains.get']('os')|lower }} {{ salt['grains.get']('osmajorrelease') }} main
    - file: /etc/apt/sources.list.d/zammad.list
    - gpgcheck: 1
    - key_url: https://dl.packager.io/srv/zammad/zammad/key

elasticsearch-repo:
  pkgrepo.managed:
    - humanname: elasticsearch
    - name: deb https://artifacts.elastic.co/packages/5.x/apt stable main
    - file: /etc/apt/sources.list.d/elastic-5.x.list
    - gpgcheck: 1
    - key_url: https://artifacts.elastic.co/GPG-KEY-elasticsearch

zammad:
  pkg.installed:
    - packages:
      - zammad
      - openjdk-8-jre
      - elasticsearch
    - require:
      - pkgrepo: zammad-repo
      - pkgrepo: elasticsearch-repo

elasticsearch-plugin-ingest-attachment:
  cmd.run:
    - name: /usr/share/elasticsearch/bin/elasticsearch-plugin install ingest-attachment
    - require:
      - pkg: zammad
    - onchanges:
      - pkg: zammad

elasticsearch.service:
  service.running:
    - enable: true
    - restart: true
    - watch:
      - cmd: elasticsearch-plugin-ingest-attachment
