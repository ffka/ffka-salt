base:
  '*':
    - common.packages
    - common.datetime
    - common.ffkaadmin
    - common.sudo
    - common.backport_repo
    - prometheus.node_exporter
    - salt.minion
    - hostname
  'core*.zkm.ka*':
    - network.lo_core
  'core*.zkm.ka* or core*.scc.kae*':
    - kernel.sysctl
    - network
    - network.tunnel
    - iproute2.backports
    - routing.bird2
    - routing.bird2.base
    - routing.bird2.ibgp
    - routing.bird2.ebgp
    - routing.bird2.exporter
    - ferm
  'core*.scc.kae*':
    - network.interfaces
    - network.vrf
  'gw*.cloud.zkm.kae.frickelfunk.net':
    - kernel.sysctl
    - routing.bird2
    - routing.bird2.base
    - routing.bird2.exporter
    - routing.bird2.internal_upstream
    - routing.bird2.internal_upstream.originator
    - routing.bird2.radv
    - network.lo
    - network.nat
    - keepalived
    - network.internal_upstream
    - network.interfaces
    - dhcpv4
    - dhcpv4.address_assignment
    - ferm
  'gw*.scc.kae.frickelfunk.net':
    - kernel.sysctl
    - routing.bird2
    - routing.bird2.base
    - routing.bird2.internal_upstream
    - routing.bird2.internal_upstream.originator
    - routing.bird2.radv
    - network.lo
    - network.nat
    - keepalived
    - network.internal_upstream
    - network.interfaces
    - dhcpv4
    - dhcpv4.address_assignment
    - ferm
    #- routing.bird2.exporter
  'dns*':
    - unbound
    - kernel.sysctl
    - network.internal_upstream
    - ferm
    - network.vrf
    - network.interfaces
    - routing.bird2
    - routing.bird2.base
    - routing.bird2.internal_upstream
    - routing.bird2.internal_upstream.originator
    - routing.bird2.internal_upstream.anycast_originator
#    - routing.bird2.exporter
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
    - dhcpv4
    - dhcpv4.domains
    - dhcpv6
    - dhcpv6.domains
    - routing.bird2
    - routing.bird2.base
    - routing.gwbat
    - routing.gwbat.domains
    - routing.gwbat.domains.radv
    - routing.gwbat.domains.device-routes
    - kernel.sysctl
    - network.ip_rt_tables_freifunk
    - network.tunnel
    - access-control.gwbat
    #- fastd.exporter
    #- dhcpv4.exporter
    #- routing.bird2.exporter
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
    - dhcpv4
    - dhcpv4.domains
    - dhcpv6
    - dhcpv6.domains
    - routing.bird2
    - routing.bird2.base
    - routing.gwbat
    - routing.gwbat.domains
    - routing.gwbat.domains.radv
    - routing.gwbat.domains.device-routes
    - kernel.sysctl
    - network.ip_rt_tables_freifunk
    - network.tunnel
    #- fastd.exporter
    #- dhcpv4.exporter
    #- routing.bird2.exporter
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
  'core0.net.entropia.de':
    - kernel.sysctl
    - network
    - network.interfaces
    - network.vrf
    - iproute2.backports
    - routing.bird2
    - routing.bird2.exporter
    - routing.entropia
    - routing.bird2.static
    - ferm
  'torrelay*.frickelfunk.net':
    - torrelay
  'web2.frickelfunk.net':
    - nginx
    - certbot
    - ferm
    - network.interfaces
  'mgmt-gw.frickelfunk.net':
    - network.interfaces
    - network.vrf
    - network.tunnel
    - network.tunnel.wireguard
    - routing.bird2
    - routing.bird2.exporter
    - routing.bird2.mgmt
  'mgmt.scc.kae.frickelfunk.net':
    - network.tunnel
    - network.tunnel.wireguard
    - routing.bird2
    - routing.bird2.exporter
    - routing.bird2.mgmt
  'loomio.vzffnrmo.de':
    - docker
    - nginx
    - certbot
    - loomio.docker
