def ipaf():
  return [
    [4, "v4", "ipv4"],
    [6, "v6", "ipv6"]
  ]

def address_from_subnet(subnet):
  try:
    import ipaddress
    parsed = ipaddress.ip_interface(subnet)
    return str(parsed.ip)
  except ImportError:
    # ToDo: remove after python3 upgrade
    return subnet.split('/')[0]

def ip_in_subnet(address, subnet):
  import ipaddress

  parsed_address = None
  try:
    parsed_address = ipaddress.ip_interface(address).ip
  except ValueError:
    try:
      parsed_address = ipaddress.ip_address(address)
    except ValueError:
      return None

  parsed_network = None
  try:
    parsed_network = ipaddress.ip_interface(subnet).network
  except ValueError:
    try:
      parsed_network = ipaddress.ip_network(subnet)
    except ValueError:
      return None

  return parsed_address in parsed_network

