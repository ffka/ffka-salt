{% macro custom_states(name, vhost, domainset) -%}

/srv/www/tiles/error.png:
  file.managed:
    - name: /srv/www/tiles/error.png
    - source: salt://nginx/files/sites/tiles/error.png
    - mode: '0644'
    - user: www-data
    - group: www-data
    - require:
      - file: /srv/www/tiles/htdocs/

{%- endmacro %}
