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
    - kea_dhcp
  'api.frickelfunk.net':
    - network
    - network.ip_rt_tables_freifunk
    - network.br_ffka
    - network.gre_ffka
    - batman
    - yanic
    - meshviewer
    - nginx
    - certbot
    - hopglass.server
  'monitor.frickelfunk.net':
    - grafana
    - prometheus
    - nginx
    - certbot
  'websrv.frickelfunk.net':
    - nginx
    - certbot
    - docker
    - discourse
  'gitlab.frickelfunk.net':
    - gitlab.runner
    - docker
  'build1.ffka.net':
    - gitlab.runner
    - docker
