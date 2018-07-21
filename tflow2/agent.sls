# States that are executed on a tflow2 agent

/etc/bird/bird.d/92-tflow2-agent.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: 644
    - template: jinja
    - source: salt://tflow2/files/bird_agent.conf.j2
    - context:
        neighbor: salt['pillar.get']('monitoring:tflow:agent:bgp_neighbor_v4')
    - require:
      - pkg: bird
      - file: /etc/bird/bird.d

/etc/bird/bird6.d/92-tflow2-agent.conf:
  file.managed:
    - user: bird
    - group: bird
    - mode: 644
    - template: jinja
    - source: salt://tflow2/files/bird_agent.conf.j2
    - context:
        neighbor: salt['pillar.get']('monitoring:tflow:agent:bgp_neighbor_v6')
    - require:
      - pkg: bird
      - file: /etc/bird/bird6.d