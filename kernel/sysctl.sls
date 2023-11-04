{% set sysctld = "/etc/sysctl.d" %}

# Reboot 1 second after kernel panic, oops or BUG
kernel.panic:
  sysctl.present:
    - value: 1
    - config: {{ sysctld }}/panic.conf

kernel.panic_on_oops:
  sysctl.present:
    - value: 1
    - config: {{ sysctld }}/panic.conf

# throw kernel panic on softlockup
kernel.softlockup_panic:
  sysctl.present:
    - value: 1
    - config: {{ sysctld }}/panic.conf


# forwarding
net.ipv4.conf.all.forwarding:
  sysctl.present:
    - value: 1
    - config: {{ sysctld }}/forward.conf

net.ipv6.conf.all.forwarding:
  sysctl.present:
    - value: 1
    - config: {{ sysctld }}/forward.conf


# Maximum number of routes allowed in the kernel
net.ipv4.route.max_size:
  sysctl.present:
    - value: 8388608
    - config: {{ sysctld }}/ipv4.conf

net.ipv6.route.max_size:
  sysctl.present:
    - value: 8388608
    - config: {{ sysctld }}/ipv6.conf



# arp/ndpar
net.ipv4.neigh.default.gc_thresh1:
  sysctl.present:
    - value: 4096
    - config: {{ sysctld }}/neigh.conf

net.ipv4.neigh.default.gc_thresh2:
  sysctl.present:
    - value: 8192
    - config: {{ sysctld }}/neigh.conf

net.ipv4.neigh.default.gc_thresh3:
  sysctl.present:
    - value: 16384
    - config: {{ sysctld }}/neigh.conf

net.ipv6.neigh.default.gc_thresh1:
  sysctl.present:
    - value: 4096
    - config: {{ sysctld }}/neigh.conf

net.ipv6.neigh.default.gc_thresh2:
  sysctl.present:
    - value: 8192
    - config: {{ sysctld }}/neigh.conf

net.ipv6.neigh.default.gc_thresh3:
  sysctl.present:
    - value: 16384
    - config: {{ sysctld }}/neigh.conf


# Disable IP source routing
net.ipv4.conf.all.send_redirects:
  sysctl.present:
    - value: 0
    - config: {{ sysctld }}/sr.conf

net.ipv4.conf.default.send_redirects:
  sysctl.present:
    - value: 0
    - config: {{ sysctld }}/sr.conf

net.ipv4.conf.all.accept_source_route:
  sysctl.present:
    - value: 0
    - config: {{ sysctld }}/sr.conf

net.ipv4.conf.default.accept_source_route:
  sysctl.present:
    - value: 0
    - config: {{ sysctld }}/sr.conf

net.ipv6.conf.all.accept_source_route:
  sysctl.present:
    - value: 0
    - config: {{ sysctld }}/sr.conf

net.ipv6.conf.default.accept_source_route:
  sysctl.present:
    - value: 0
    - config: {{ sysctld }}/sr.conf


# Increase the r/w-buffer-space allocatable

#core
net.core.rmem_max:
  sysctl.present:
    - value: 8388608
    - config: {{ sysctld }}/rmem.conf

#core
net.core.rmem_default:
  sysctl.present:
    - value: 8388608
    - config: {{ sysctld }}/rmem.conf

#nc
net.ipv4.udp_rmem_min:
  sysctl.present:
    - value: 16384
    - config: {{ sysctld }}/rmem.conf

#core
net.core.wmem_max:
  sysctl.present:
    - value: 8388608
    - config: {{ sysctld }}/wmem.conf

#core
net.core.wmem_default:
  sysctl.present:
    - value: 8388608
    - config: {{ sysctld }}/wmem.conf

#nc
net.ipv4.udp_wmem_min:
  sysctl.present:
    - value: 16384
    - config: {{ sysctld }}/wmem.conf

net.core.somaxconn:
  sysctl.present:
    - value: 16384
    - config: {{ sysctld }}/core.conf

net.core.netdev_max_backlog:
  sysctl.present:
    - value: 16384
    - config: {{ sysctld }}/core.conf



# Accept Redirects; default = 0
net.ipv6.conf.default.accept_redirects:
  sysctl.present:
    - value: 1
    - config: {{ sysctld }}/ipv6.conf
net.ipv6.conf.all.accept_redirects:
  sysctl.present:
    - value: 1
    - config: {{ sysctld }}/ipv6.conf

# Accept Duplicate Address Detection; default = 1
net.ipv6.conf.default.accept_dad:
  sysctl.present:
    - value: 0
    - config: {{ sysctld }}/ipv6.conf
net.ipv6.conf.all.accept_dad:
  sysctl.present:
    - value: 0
    - config: {{ sysctld }}/ipv6.conf

# Increase the maximum memory used to reassemble IP fragments

net.ipv4.ipfrag_low_thresh:
  sysctl.present:
    - value: 446464
    - config: {{ sysctld }}/ipv4.conf

net.ipv4.ipfrag_high_thresh:
  sysctl.present:
    - value: 846464
    - config: {{ sysctld }}/ipv4.conf


net.ipv6.ip6frag_low_thresh:
  sysctl.present:
    - value: 446464
    - config: {{ sysctld }}/ipv6.conf


# Accept ICMP redirect messages; default = 0
net.ipv4.conf.default.accept_redirects:
  sysctl.present:
    - value: 1
    - config: {{ sysctld }}/ipv4.conf

net.ipv4.conf.all.accept_redirects:
  sysctl.present:
    - value: 1
    - config: {{ sysctld }}/ipv4.conf

# VRF no lose IPv6 Magic
net.ipv6.conf.all.keep_addr_on_down:
  sysctl.present:
    - value: 1
    - config: {{ sysctld }}/vrf.conf

net.ipv4.conf.tcp_l3mdev_accept:
  sysctl.present:
    - value: 1
    - config: {{ sysctld }}/vrf.conf
net.ipv4.conf.udp_l3mdev_accept:
  sysctl.present:
    - value: 1
    - config: {{ sysctld }}/vrf.conf
