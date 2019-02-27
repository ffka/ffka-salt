def get_prefixes(af, metro, location):
  glob = __salt__['pillar.get']('routing:prefixes:{}:global'.format(af), [])
  metro = __salt__['pillar.get']('routing:prefixes:{}:metro:{}'.format(af, metro.upper()), [])
  loc = __salt__['pillar.get']('routing:prefixes:{}:location:{}'.format(af, location.upper()), [])
  return glob + metro + loc
