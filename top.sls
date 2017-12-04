base:
  '*':
    - common.packages
    - common.datetime
    - common.ffkaadmin
    - common.sudo
    - common.netdata
  'albufer*':
    - kernel
    - kernel.sysctl
    - network
    - network.ip_rt_tables_freifunk
    - network.br_ffka
    - network.gre_ffka
    - network.gre_ffrl
    - network.lo_ffka
    - routing
    - batman
    - ntp
    - ferm
    - mesh_vpn
    - mesh_vpn.server
    - radvd
    - dhcp
    - dns
    - respondd
    - nat64
  'api.frickelfunk.net':
    - network
    - network.ip_rt_tables_freifunk
    - network.br_ffka
    - network.gre_ffka
    - mesh_vpn
    - mesh_vpn.client
    - batman
    - yanic
    - meshviewer
  'monitor.frickelfunk.net':
    - grafana
    - prometheus
