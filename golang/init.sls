{%- from 'golang/map.jinja' import golang with context %}

golang:
  pkg.installed:
    - pkgs: {{ golang['packages'] | yaml }}
{%- if 'fromrepo' in golang %}
    - fromrepo: {{ golang['fromrepo'] }}
{%- endif %}

# manage the `go` symlink manually as golang-go is too opinionated about
# which go version to choose and cannot be reconfigured.
golang-go:
  pkg.purged

/usr/bin/go:
  file.symlink:
    - target: {{ golang['go_executable'] }}
    - force: True

golang-env:
  file.managed:
     - name: /etc/profile.d/go
     - contents:
         export GOPATH={{ pillar.get('golang:gopath', '/usr/local/go') }}
         export PATH=$PATH:$GOPATH/bin
