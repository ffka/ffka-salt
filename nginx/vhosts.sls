{% for vhost in salt['pillar.get']('nginx:vhosts', []) %}

{%- set name = vhost.site_name -%}
{%- set domainset = salt['pillar.get']('domainsets:' ~ vhost.domainset, []) -%}

{%- set create_user = vhost.get('user', False) -%}

{% if create_user %}
{% set owner = name %}

user_{{ owner }}:
  user.present:
    - name: {{ owner }}
    - createhome: False
    - home: /srv/www/{{ name }}/
{%- if vhost.get('webroot', False) %}
    - require_in:
      - file: {{ name }}_webroot
{% endif %}

/srv/www/{{ name }}/:
  file.directory:
    - user: {{ owner }}
    - group: www-data
    - makedirs: True
    - require:
      - user: user_{{ name }}
    - require_in:
      - test: nginx_{{ name }}

{% for ssh_key in vhost.get('deploy_keys', []) %}
sshkey {{ ssh_key.key }} for {{ owner }}:
  ssh_auth.present:
    - user: {{ owner }}
    - enc: {{ ssh_key.enc }}
    - name: {{ ssh_key.key }}
{% endfor %}

{% else %}
{% set owner = "www-data" %}
{% endif %}

/etc/nginx/sites-available/{{ name }}.conf:
  file.managed:
    - source: salt://nginx/files/sites/{{ name }}.conf.j2
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
      site_name: '{{ name }}'
      hostnames: '{{ domainset|join(' ') }}'
      vhost: {{ vhost }}
      certificate_filename: {{ domainset[0] }}
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/{{ name }}.conf:
{% if not vhost.get('disabled', False) %}
  file.symlink:
    - target: /etc/nginx/sites-available/{{ name }}.conf
{% else %}
  file.absent
{% endif %}

{% if vhost.get('webroot', False) %}
{{ name }}_webroot:
  file.directory:
    - name: /srv/www/{{ name }}/htdocs/
    - user: {{ owner }}
    - group: www-data
    - makedirs: True
    - require_in:
      - test: nginx_{{ name }}

{% if vhost.get('sync_webroot', False) %}
{{ name }}_webroot_content:
  file.recurse:
    - name: /srv/www/{{ name }}/htdocs/
    - source: salt://nginx/files/sites/{{ name }}/
    - clean: True
    - file_mode: 0644
    - dir_mode: 0755
    - user: {{ owner }}
    - group: www-data
    - template: jinja
    - require:
      - file: {{ name }}_webroot
    - require_in:
      - test: nginx_{{ name }}
{% endif %}
{% endif %}

/var/log/nginx/{{ name }}:
  file.directory:
    - user: www-data
    - group: www-data
    - require_in:
      - test: nginx_{{ name }}

# noop state that other changed can depend on; success indicates that the vhost is set up completely
nginx_{{ name }}:
  test.nop:
    - require:
      {% if create_user -%}- user: user_{{ owner }}{%- endif %}
      - file: /etc/nginx/sites-available/{{ name }}.conf
      - file: /var/log/nginx/{{ name }}

{% if vhost.get('custom_states', False) %}
# site has custom states -> include states isolated (in with section), and call the macro

{% with %}
{% from 'nginx/sites/' ~ name ~ '.sls' import custom_states %}
{{ custom_states(name, vhost, domainset) }}
{% endwith %}

{% endif %}

{% endfor %}
