install bird:
  pkg.installed:
    - name: bird

{% for bird in ['bird','bird6'] %}
place bgp {{bird}}.conf:
  file.managed:
    - name: /etc/bird/{{bird}}.conf
    - source: salt://bgp/files/{{bird}}.conf.j2
    - template: jinja
    - context:
        network: {{ pillar['network'] }}
        ffka: {{ pillar['ffka'] }}



service {{bird}}:
  service.running:
    - name: {{ bird }}
    - enable: true
    - reload: true
    - watch:
      - file: place bgp {{bird}}.conf
{% endfor %}