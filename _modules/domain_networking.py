def generate_ifname(domain, iftype=None):
  if iftype is None:
  	return 'dom{0:02d}'.format(domain['domain_id'])
  return 'dom{0:02d}-{1:s}'.format(domain['domain_id'], iftype)