bird:
  pkg.purged

/etc/systemd/system/bird2.service:
  file.managed:
    - source: salt://routing/files/bird2/bird2.service
    - user: root
    - group: root
    - mode: 644

/etc/bird2/bird.d/:
  file.directory:
    - mode: 644
    - makedirs: True

bird2.service:
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: /etc/systemd/system/bird2.service
    - watch:
      - /etc/bird2/bird.conf
      - /etc/bird2/bird.d/*

/etc/bird2/bird.conf:
  file.managed:
    - contents: |
        include "bird.d/*.conf";
    - user: root
    - group: root
    - mode: 664
    - require:
      - file: /etc/bird2/bird.d/

{% for dir in ["transits", "ixps", "peerings", "customers", "ibgp", "internal_downstreams"] %}
/etc/bird2/bird.d/{{ dir }}/:
  file.directory:
    - mode: 644
    - require:
      - file: /etc/bird2/bird.d/
{% endfor %}

{% for file in ["05-communities", "06-constants", "10-basic-settings", "20-basic-protocols", "25-igp", "30-policy-communities", "31-policy-ebgp-in-basic", "31-policy-ebgp-out-basic", "31-policy-ibgp-in-basic", "39-policy-ebpg", "39-policy-ibgp", "40-bgp-base", "45-bgp-sessions"] %}
/etc/bird2/bird.d/{{ file }}.conf:
  file.managed:
    - source:
      - salt://routing/files/bird2/bird.d/{{ file }}.conf
      - salt://routing/files/common/{{ file }}.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/bird2/bird.d/
{% endfor %}

include:
  - routing.bird2.ibgp
  - routing.bird2.ebgp
