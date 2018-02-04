{% set sysctld = "/etc/sysctl.d" %}

{% for hoodname in salt['pillar.get']('hoods') %}
net.ipv6.conf.br_{{ hoodname }}.accept_dad:
  sysctl.present:
    - value: 0
    - config: {{ sysctld }}/br_{{ hoodname }}.conf
{% endfor %)}

# conntrack
nf_conntrack:
  kmod.present:
    - persist: True

net.netfilter.nf_conntrack_max:
  sysctl.present:
    - value: 1048576
    - config: {{ sysctld }}/conntrack.conf

net.netfilter.nf_conntrack_tcp_timeout_established:
  sysctl.present:
    - value: 54000
    - config: {{ sysctld }}/conntrack.conf

net.netfilter.nf_conntrack_generic_timeout:
  sysctl.present:
    - value: 120
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

#RP_Filter

net.ipv4.conf.default.rp_filter:
  sysctl.present:
    - value: 0
    - config: {{ sysctld }}/rp_filter.conf

net.ipv4.conf.all.rp_filter:
  sysctl.present:
    - value: 0
    - config: {{ sysctld }}/rp_filter.conf

net.core.rmem_max:
  sysctl.present:
    - value: 67108864
    - config: {{ sysctld }}/rmem_max.conf

net.core.rmem_default:
  sysctl.present:
    - value: 8388608
    - config: {{ sysctld }}/rmem_default.conf

net.core.wmem_max:
  sysctl.present:
    - value: 67108864
    - config: {{ sysctld }}/wmem_max.conf

net.core.netdev_max_backlog:
  sysctl.present:
    - value: 250000
    - config: {{ sysctld }}/netdev_max_backlog.conf

net.core.somaxconn:
  sysctl.present:
    - value: 4096
    - config: {{ sysctld }}/netdev_max_backlog.conf

net.core.optmem_max:
  sysctl.present:
    - value: 2048000
    - config: {{ sysctld }}/netdev_optmem_max.conf
