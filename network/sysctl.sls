{% set sysctld = "/etc/sysctl.d" %}

# conntrack
nf_conntrack:
  kmod.present:
    - persist: True

net.netfilter.nf_conntrack_max:
  sysctl.present:
    - value: 256000
    - config: {{ sysctld }}/conntrack.conf

# arp/ndp
net.ipv4.neigh.default.gc_thresh1:
  sysctl.present:
    - value: 2048
    - config: {{ sysctld }}/neigh.conf

net.ipv4.neigh.default.gc_thresh2:
  sysctl.present:
    - value: 4096
    - config: {{ sysctld }}/neigh.conf

net.ipv4.neigh.default.gc_thresh3:
  sysctl.present:
    - value: 8192
    - config: {{ sysctld }}/neigh.conf

net.ipv6.neigh.default.gc_thresh1:
  sysctl.present:
    - value: 2048 
    - config: {{ sysctld }}/neigh.conf

net.ipv6.neigh.default.gc_thresh2:
  sysctl.present:
    - value: 4096
    - config: {{ sysctld }}/neigh.conf

net.ipv6.neigh.default.gc_thresh3:
  sysctl.present:
    - value: 8192
    - config: {{ sysctld }}/neigh.conf

# forwarding
net.ipv4.conf.all.forwarding:
  sysctl.present:
    - value: 1
    - config: {{ sysctld }}/forward.conf

net.ipv6.conf.all.forwarding:
  sysctl.present:
    - value: 1
    - config: {{ sysctld }}/forward.conf

net.core.rmem_max:
  sysctl.present:
    - value: 8388608
    - config: {{ sysctld }}/rmem_max.conf

net.core.rmem_default:
  sysctl.present:
    - value: 8388608
    - config: {{ sysctld }}/rmem_default.conf
