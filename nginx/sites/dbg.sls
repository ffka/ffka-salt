{% macro custom_states(name, vhost, domainset) -%}

{% for size in ["100M", "1G", "10G"] %}

/srv/www/dbg/htdocs/{{ size }}:
  cmd.run:
    - name: truncate -s {{ size }} /srv/www/dbg/htdocs/{{ size }}
    - unless: test -f /srv/www/dbg/htdocs/{{ size }}
{% endfor %}

{%- endmacro %}
