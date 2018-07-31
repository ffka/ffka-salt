def _get_sites_with_role(sites, role):
    return [site for site in sites if any(role in ifa['roles'] for ifa in site['interfaces'])]

def _get_site(sites, site):
    return next(ifilter(lambda s: s['site'] == site, sites), None)

def _get_interface_with_role(interfaces, role):
	return next(ifilter(lambda iface: role in iface['roles'], interfaces), None)

""" This function finds interface combinations between two bat getways that can be used for
a specified role, e.g. for mesh or routing traffic.
"""
def find_interface_combination(my_id, other_id, role):
    bat_gateways = __salt__['pillar.get']('gwbat')
    
    my_sites =  _get_sites_with_role(bat_gateways.get(my_id, {}).get('sites', []), role)
    other_sites = _get_sites_with_role(bat_gateways.get(other_id, {}).get('sites', []), role)

    matching_sites = [site for site in my_sites if any(other_site['site'] == site['site'] for other_site in other_sites)]

    if len(matching_sites) == 0:
    	return False

    matching_site = matching_sites[0]['site']

    my_site = _get_site(my_sites, matching_site)
    other_site = _get_site(other_sites, matching_site)

    my_interface = _get_interface_with_role(my_site['interfaces'], role)
    other_interface = _get_interface_with_role(other_site['interfaces'], role)

    return {
        'my': my_interface,
        'other': other_interface
    }
