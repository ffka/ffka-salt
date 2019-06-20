{% macro custom_states(name, vhost, domainset) -%}

/srv/www/dbg/htdocs/speedtest:
  file.directory:
    - require:
      - test: nginx_dbg

{% for size in ["100M", "1G", "10G"] %}
/srv/www/dbg/htdocs/speedtest/{{ size }}:
  cmd.run:
    - name: truncate -s {{ size }} /srv/www/dbg/htdocs/speedtest/{{ size }}
    - unless: test -f /srv/www/dbg/htdocs/speedtest/{{ size }}
    - require:
      - file: /srv/www/dbg/htdocs/speedtest
{% endfor %}

{%- endmacro %}
