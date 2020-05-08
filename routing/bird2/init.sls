/etc/apt/preferences.d/bird2:
  file.managed:
    - contents: |
        Package: bird2
        Pin: release n=unstable
        Pin-Priority: 800

bird:
  pkg.purged

/etc/bird2:
  file.absent

bird2:
  pkg.installed:
    - require:
      - file: /etc/bird2
      - file: /etc/apt/preferences.d/bird2
      - pkgrepo: unstable
      - pkg: bird

/etc/bird/bird.d/:
  file.directory:
    - mode: '0755'
    - user: bird
    - group: bird
    - makedirs: True
    - require:
      - pkg: bird2

bird.service:
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: bird2
    - watch:
      - /etc/bird/bird.conf
      - /etc/bird/bird.d/*

/etc/bird/bird.conf:
  file.managed:
    - contents: |
        include "bird.d/*.conf";
    - user: bird
    - group: bird
    - mode: '0664'
    - require:
      - pkg: bird2

{% for file in ["05-communities", "06-constants", "10-basic-settings", "20-basic-protocols", "30-policy-communities", "39-policy-internal-downstreams", "45-bgp-sessions"] %}
/etc/bird/bird.d/{{ file }}.conf:
  file.managed:
    - source:
      - salt://routing/files/bird2/bird.d/{{ file }}.conf
      - salt://routing/files/common/{{ file }}.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: '0755'
    - require:
      - file: /etc/bird/bird.d/
{% endfor %}

include:
  - common.debian_unstable
