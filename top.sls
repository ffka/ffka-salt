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
    - routing
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
    - mesh_announce
    - nat64
    - kea_dhcp
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
  'core0.zkm.ka*':
    - kernel.backports
    - kernel.sysctl
    - network
    - network.lo_core
    - network.he_tunnel
    - network.cloud_gateway
    - network.gre_ffffm_uplink
    - network.tunnel
    - routing
    - routing.core
    - routing.core.core_bat
    - routing.cloud_gateway
    - snmpd
    - ferm
    - ferm.core
    - netflow
    - tflow2.agent
  'core1.zkm.ka*':
    - kernel.backports
    - kernel.sysctl
    - network
    - network.tunnel
    - network.lo_core
    - routing.backbone
  'edge.ntsltr.fra*':
    - kernel.backports
    - kernel.sysctl
    - network
    - network.tunnel
    - network.lo_core
    - routing.backbone
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
  'runner-vm* or gitlab-runner-nitrado.frickelfunk.net or build1.ffka.net':
    - gitlab.runner
    - docker
    - ferm
  'gitlab.frickelfunk.net':
    - gitlab.gitlab
    - netdata
    - certbot
  'ns1.frickelfunk.net':
    - knot
  'tickets.frickelfunk.net':
    - zammad
    - nginx
    - certbot
  'testbed.frickelfunk.net':
    - jool
    - netflow
    - ferm
    - network.tunnel
  'gwbattb*.frickelfunk.net':
    - kernel.backports
    - batman
    - ferm
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
    - routing.gwbat.bat_core
    - routing.gwbat.domains
    - routing.gwbat.domains.radv
    - kernel.sysctl
    - network.ip_rt_tables_freifunk
    - routing.domains.device-routes
    - network.tunnel
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
    - routing.gwbat.bat_core
    - routing.gwbat.domains
    - routing.gwbat.domains.radv
    - routing.gwbat.domains.device-routes
    - kernel.sysctl
    - network.ip_rt_tables_freifunk
    - network.tunnel
  'domain-director.frickelfunk.net':
    - domain-director
