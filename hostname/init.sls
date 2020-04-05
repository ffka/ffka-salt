# based on https://julez.dev/sysop/salt/-/tree/master/salt%2Fhostname, revision 4e7b10cdd09b1353390ecea1032aa8ab17511d93

fqdn-pillar:
  test.check_pillar:
    - string:
      - fqdn

hostnamectl set-hostname {{ salt['pillar.get']('fqdn') }}:
  cmd.run:
    - unless: "[ $(hostname --fqdn) = \"{{ salt['pillar.get']('fqdn') }}\" ]"
    - require:
      - test: fqdn-pillar

# host.present doesn't work as it doesn't apply the specified order
ipv4 @ /etc/hosts:
  file.line:
    - name: /etc/hosts
    - content: 127.0.0.1		{{ salt['pillar.get']('fqdn') }} localhost.localdomain localhost
    - mode: replace
    - match: ^127.0.0.1
    - require:
      - test: fqdn-pillar

ipv6 @ /etc/hosts:
  file.line:
    - name: /etc/hosts
    - content: ::1		{{ salt['pillar.get']('fqdn') }} ip6-localhost ip6-loopback localhost.localdomain localhost
    - mode: replace
    - match: ^::1
    - require:
      - test: fqdn-pillar

/etc/mailname:
  file.managed:
    - contents: {{ salt['pillar.get']('fqdn') }}
    - require:
      - test: fqdn-pillar

oob_hostname:
  grains.present:
    {% if salt['pillar.get']('oob_hostname') %}
    - value: {{ salt['pillar.get']('oob_hostname') }}
    {% else %}
    - value: {{ salt['pillar.get']('hostname') }}
    {% endif %}
    - require:
      - test: hostname-pillar
