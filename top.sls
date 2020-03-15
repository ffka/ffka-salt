base:
  '*':
    - common.packages
    - common.datetime
    - common.ffkaadmin
    - common.sudo
    - common.backport_repo
    - netdata
    - prometheus.exporters.node
    - salt.minion
  'core*.zkm.ka*':
#    - kernel.backports
    - kernel.sysctl
    - network
    - network.lo_core
    - network.tunnel
    - iproute2.backports
    - routing.bird2
    - ferm
    - prometheus.exporters.bird
#    - snmpd
#    - netflow
#    - tflow2.agent
  'cloud-router.zkm.ka.frickelfunk.net':
    - kernel.sysctl
    - routing.bird
    - routing.internal_upsteam_originator
    - routing.radv
    - network.lo
    - network.nat
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
    - kernel.sysctl
    - network.lo
    - network.internal_upstream
    - routing.bird
    - routing.internal_upsteam_originator
    - ferm
  'nat64*.frickelfunk.net':
    - kernel.sysctl
    - network.lo
    - network.internal_upstream
    - routing.bird
    - routing.internal_upsteam_originator
    - ferm
    - jool
  'monitor.frickelfunk.net':
    - grafana
    - prometheus
    - nginx
    - certbot
    - network.tunnel
    - routing.bird
  'monitoring.frickelfunk.net':
    - prometheus
  'websrv.frickelfunk.net':
    - nginx
    - certbot
    - docker
    - ferm
    - discourse
    - meshviewer
    - grafana.docker
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
    - access-control.gwbat
  'gwffwp*.frickelfunk.net':
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
  'domain-director.frickelfunk.net':
    - domain-director
  'speedtest.frickelfunk.net':
    - apt.unattended-upgrades
  '^api(ffka|ffwp).frickelfunk.net$':
    - match: pcre
    - network
    - network.domains
    - network.domains.mesh
    - network.gwbat_internal
    - ferm
    - batman
    - yanic
    - nginx
  'influxdb.api.frickelfunk.net':
    - influxdb
  'zutrittskontrolle.frickelfunk.net':
    - docker
    - access-control
    - nginx
