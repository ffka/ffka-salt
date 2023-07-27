import itertools

def generate_ifname(community_id, domain, iftype=None, suffix=None):
  if_prefix = ('dom{1:02d}' if community_id == 0 else 'dom{0:01d}{1:02d}').format(community_id, domain['domain_id'])

  if iftype is None and suffix is None:
    return if_prefix
  if iftype is None:
    return if_prefix + '-{0:s}'.format(suffix)
  if suffix is None:
    return if_prefix + '-{0:s}'.format(iftype)

  max_suffix_length = 15 - (len(if_prefix) + 5)
  return if_prefix + '-{0:s}-{1:s}'.format(iftype, suffix[:(max_suffix_length - 1)])

def generate_mac(type, community_id, domain, host_id, instance_id=None):
  if type == 'br':
    return ":".join([
      'fc',
      '{0:02x}'.format(0xcb + community_id),
      'ff',
      '00',
      '{0:02x}'.format(domain['domain_id']),
      '{0:02x}'.format(host_id)])
  elif type == 'bat':
    return ":".join([
      'fc',
      '{0:02x}'.format(0xba + community_id),
      '1f',
      'ff',
      '{0:02x}'.format(domain['domain_id']),
      '{0:02x}'.format(host_id)])
  elif type == 'fastd':
    return ":".join([
      'fc',
      '{0:02x}'.format(0xfa + community_id),
      '51',
      '{0:02x}'.format(domain['domain_id']),
      '{0:02x}'.format(host_id),
      '{0:02x}'.format(instance_id)])
  elif type == 'mesh':
    return ":".join([
      'fc',
      '{0:02x}'.format(0xe5 + community_id),
      '17',
      '{0:02x}'.format(domain['domain_id']),
      '{0:02x}'.format(host_id),
      '{0:02x}'.format(instance_id)])
  else:
    return "INVALID"

def domain_names(community=None):
  domains = {}
  for domain in get_domains(community).values():
    for code, name in domain['domain_names'].items():
      domains[code] = name
  return domains

def get_domains_for_communities(communities):
  community_id_map = __salt__['pillar.get']('community_ids')
  domains_per_community = [
    [(community_id_map[c], c, dom_id, dom) for (dom_id, dom) in __salt__['pillar.get']('{}:domains'.format(c)).items()]
    for c in community_id_map.keys()
  ]
  return itertools.chain(*domains_per_community)

def get_domains(community=None):
  if community is None:
    community = __salt__['pillar.get']('community')
  return __salt__['pillar.get']('{}:domains'.format(community))
