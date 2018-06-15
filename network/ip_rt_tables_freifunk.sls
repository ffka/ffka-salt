name ip rule tables:
  file.blockreplace:
    - name: /etc/iproute2/rt_tables
    - marker_start: "# START managed Freifunk table --"
    - marker_end: "# END managed Freifunk table --"
    - append_if_not_found: True
    - content:  |
        10   vzffnrmo
        16   freifunk
