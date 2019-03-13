base:
  '*':
    - common.packages
    - common.datetime
    - common.ffkaadmin
    - common.sudo
    - common.backport_repo
    - netdata
  'albufer*':
    - kernel.backports
    - kernel.sysctl
    - network
    - network.ip_rt_tables_freifunk
    - network.br_ffka
    - network.gre_ffka
    - network.gre_ffrl
    - network.lo
    - network.tunnel
    - routing.bird
    - routing.albufer
    - routing.albufer_gateway_bat
    - batman
    - network.batman
    - ntp
    - ferm
    - ferm.gw
    - mesh_vpn
    - mesh_vpn.server
    - dhcp
    - dns
    - nat64
  'api.frickelfunk.net':
    - network
    - network.ip_rt_tables_freifunk
    - network.br_ffka
    - network.gre_ffka
    - network.domains
    - network.domains.mesh
    - network.gwbat_internal
    - ferm
    - batman
    - network.batman
    - yanic
    - meshviewer
    - nginx
    - certbot
    - hopglass.server
    - docker
    - influxdb
  'core*.zkm.ka*':
    - kernel.backports
    - kernel.sysctl
    - network
    - network.lo_core
    - network.tunnel
    - iproute2.backports
    - routing.bird2
    - ferm
#    - snmpd
#    - netflow
#    - tflow2.agent
  'cloud-router.zkm.ka.frickelfunk.net':
    - kernel.backports
    - kernel.sysctl
    - routing.bird
    - routing.cloud_router
    - network.internal_upstream
    - dhcpv4
    - dhcpv4.address_assignment
    - ferm
  'edge.ntsltr.fra*':
    - kernel.backports
    - kernel.sysctl
    - iproute2.backports
    - network
    - network.tunnel
    - network.lo_core
    - routing.bird2
  'dns*':
    - unbound
  'monitor.frickelfunk.net':
    - grafana
    - prometheus
    - nginx
    - certbot
    - network.tunnel
    - golang
    - tflow2
    - routing.bird
  'websrv.frickelfunk.net':
    - nginx
    - certbot
    - docker
    - ferm
    - discourse
  'unifi.frickelfunk.net':
    - unifi
  'unms.frickelfunk.net':
    - docker
    - unms
  'runner-vm*':
    - gitlab.runner
    - docker
    - ferm
  'gitlab.frickelfunk.net':
    - gitlab.gitlab
    - apt.unattended-upgrades
    - netdata
    - certbot
  'ns1.frickelfunk.net':
    - knot
  'tickets.frickelfunk.net':
    - zammad
    - nginx
    - certbot
  'gwbat*.frickelfunk.net':
    - kernel.backports
    - batman
    - ferm
    - ferm.gwbat
    - network
    - network.domains
    - network.domains.mesh
    - network.gwbat_internal
    - fastd
    - fastd.domains
    - dhcpv4
    - dhcpv4.domains
    - dhcpv6
    - dhcpv6.domains
    - routing.bird
    - routing.gwbat.kernel_as202329
    - routing.gwbat.domains
    - routing.gwbat.domains.radv
    - routing.gwbat.domains.device-routes
    - routing.gwbat.internal_upstream
    - kernel.sysctl
    - network.ip_rt_tables_freifunk
    - network.tunnel
    - mesh-announce
    - mesh-announce.domains
  'domain-director.frickelfunk.net':
    - domain-director
  'speedtest.frickelfunk.net':
    - apt.unattended-upgrades
