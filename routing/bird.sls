install bird:
  pkg.installed:
    - name: bird


/etc/bird/bird.d:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

{% for bird in ['bird','bird6'] %}
place bgp {{bird}}.conf:
  file.managed:
    - name: /etc/bird/{{bird}}.conf
    - source: salt://routing/files/{{bird}}.conf.j2
    - template: jinja
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}
        dhcp: {{ pillar['dhcp'] }}



service {{bird}}:
  service.running:
    - name: {{ bird }}
    - enable: true
    - reload: true
    - watch:
      - file: place bgp {{bird}}.conf
{% endfor %}
