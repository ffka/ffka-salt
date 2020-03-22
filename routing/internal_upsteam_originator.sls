{%- for bird, af in [['bird', 'ipv4'], ['bird6', 'ipv6']] %}
/etc/bird/{{ bird }}.d/50-internal-upstreams-basic.conf:
  file.managed:
    - contents: |
        template bgp internal_upstream {
        };
    - user: bird
    - group: bird
    - mode: '0644'
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/{{ bird }}.d
    - watch_in:
      - service: {{ bird }}

{% for number, file in [[20, "basic-protocols"], [21, "static-routes"]] %}
/etc/bird/{{ bird }}.d/{{ number }}-{{ file }}.conf:
  file.managed:
    - source:
      - salt://routing/files/{{ bird }}.d/internal_upsteam_originator/{{ file }}.conf
      - salt://routing/files/common/{{ file }}.conf
    - template: jinja
    - user: bird
    - group: bird
    - mode: '0644'
    - context:
      af: {{ af }}
    - require:
      - pkg: bird
      - user: bird
      - file: /etc/bird/{{ bird }}.d
    - watch_in:
      - service: {{ bird }}
{% endfor %}
{% endfor %}

include:
  - routing.internal_upstream
