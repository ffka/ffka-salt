
{% if salt['grains.get']('osfinger') == 'Debian-9' %}
{% set go_version = "1.11" %}
golang:
  pkg.installed:
    - name: golang-{{ go_version }}-go
    - fromrepo: stretch-backports
{% else %}
{% set go_version = "1.11" %}
golang:
  pkg.installed:
    - name: golang-{{ go_version }}-go
{% endif %}

/usr/bin/go:
  file.symlink:
    - target: /usr/lib/go-{{ go_version }}/bin/go
    - force: True
    - require:
      - pkg: golang

golang-env:
  file.managed:
    - name: /etc/profile.d/go
    - contents:
         export GOPATH={{ pillar.get('golang:gopath', '/usr/local/go') }}
         export PATH=$PATH:$GOPATH/bin
    - require:
      - pkg: golang
