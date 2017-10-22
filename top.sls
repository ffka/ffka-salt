base:
  '*':
    - common.packages
    - common.datetime
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
    - mesh-vpn
