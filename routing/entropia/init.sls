{%- for name, peer in salt['pillar.get']('routing:ebgp', {}).items() %}
/etc/bird/bird.d/{{ peer['type'] }}s/{{ name }}.conf:
  file.managed:
    - source: salt://routing/files/bird2/session_templates/{{ peer['type'] }}.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: '0644'
    - context:
        name: {{ name }}
        peer: {{ peer | yaml }}
    - require:
      - file: /etc/bird/bird.d/{{ peer['type'] }}s/
{% endfor %}

{% for no, file in [[5, "communities"], [6, "constants"], [10, "basic-settings"], [20, "basic-protocols"], [30, "policy-communities"], [31, "policy-ebgp-in-basic"], [31, "policy-ebgp-out-basic"], [39, "policy-ebpg"], [40, "ebgp-base"], [41, "basic-protocols-originated-prefixes"], [45, "ebgp-sessions"]] %}
/etc/bird/bird.d/{{ '%02d' % (no) }}-{{ file }}.conf:
  file.managed:
    - source:
      - salt://routing/files/entropia/bird.d/{{ '%02d' % (no) }}-{{ file }}.conf
      - salt://routing/files/entropia/bird.d/{{ file }}.conf
      - salt://routing/files/bird2/bird.d/{{ '%02d' % (no) }}-{{ file }}.conf
      - salt://routing/files/bird2/bird.d/{{ file }}.conf
      - salt://routing/files/common/{{ '%02d' % (no) }}-{{ file }}.conf
      - salt://routing/files/common/{{ file }}.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: '0644'
    - require:
      - file: /etc/bird/bird.d/
{% endfor %}

{% for dir in ["transits", "ixps", "peerings", "customers"] %}
/etc/bird/bird.d/{{ dir }}/:
  file.directory:
    - mode: '0755'
    - user: bird
    - group: bird
    - require:
      - file: /etc/bird/bird.d/
{% endfor %}
