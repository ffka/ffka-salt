base:
  '*':
    - common.packages
    - common.datetime
    - common.ffkaadmin
    - common.sudo
    - common.backport_repo
    - netdata
    - prometheus.node_exporter
    - salt.minion
    - hostname
  'core*.zkm.ka*':
    - kernel.sysctl
    - network
    - network.lo_core
    - network.tunnel
    - iproute2.backports
    - routing.bird2
    - routing.bird2.ibgp
    - routing.bird2.ebgp
    - routing.bird2.exporter
    - ferm
  'gw*.cloud.zkm.kae.frickelfunk.net':
    - kernel.sysctl
    - routing.bird2
    - routing.bird2.exporter
    - routing.bird2.internal_upstream
    - routing.bird2.internal_upstream.originator
    - routing.radv
    - network.lo
    - network.nat
    - network.keepalived
    - network.internal_upstream
    - network.interfaces
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
    - routing.bird2.ibgp
    - routing.bird2.ebgp
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
    - nginx
    - certbot
    - network.tunnel
    - routing.bird
  'monitoring.frickelfunk.net':
    - prometheus.server
    - prometheus.alertmanager
    - nginx
    - certbot
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
    - batman
    - ferm
    - ferm.gwbat
    - network
    - network.domains
    - network.domains.mesh
    - network.gwbat_internal
    - network.interfaces
    - network.vrf
    - fastd
    - fastd.domains
    - fastd.exporter
    - dhcpv4
    - dhcpv4.domains
    - dhcpv4.exporter
    - dhcpv6
    - dhcpv6.domains
    - routing.bird2
    - routing.bird2.exporter
    - routing.gwbat
    - routing.gwbat.domains
    - routing.gwbat.domains.radv
    - routing.gwbat.domains.device-routes
    - kernel.sysctl
    - network.ip_rt_tables_freifunk
    - network.tunnel
    - access-control.gwbat
  'gwffwp*.frickelfunk.net':
    - batman
    - ferm
    - ferm.gwbat
    - network
    - network.domains
    - network.domains.mesh
    - network.gwbat_internal
    - network.interfaces
    - network.vrf
    - fastd
    - fastd.domains
    - fastd.exporter
    - dhcpv4
    - dhcpv4.domains
    - dhcpv4.exporter
    - dhcpv6
    - dhcpv6.domains
    - routing.bird2
    - routing.bird2.exporter
    - routing.gwbat
    - routing.gwbat.domains
    - routing.gwbat.domains.radv
    - routing.gwbat.domains.device-routes
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
