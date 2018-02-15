base:
  '*':
    - common.packages
    - common.datetime
    - common.ffkaadmin
    - common.sudo
    - netdata
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
    - ferm.gw
    - mesh_vpn
    - mesh_vpn.server
    - radvd
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
    - batman
    - yanic
    - meshviewer
    - nginx
    - certbot
    - hopglass.server
    - docker
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
  'unms.frickelfunk.net':
    - docker
    - unms
  'runner-vm* or build1.ffka.net':
    - gitlab.runner
    - docker
    - ferm
  'gitlab.frickelfunk.net':
    - gitlab.gitlab
    - netdata