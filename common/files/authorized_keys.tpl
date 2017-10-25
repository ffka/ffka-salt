{% for key in pillar['ffkaadmin']['ssh']['authorized_keys'] -%}
{{ key }}
{% endfor %}
