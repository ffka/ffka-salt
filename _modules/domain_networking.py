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

def domain_names():
  domains = {}
  for domain in __salt__['pillar.get']('domains').values():
    for code, name in domain['domain_names'].items():
      domains[code] = name.decode('utf-8')
  return domains
