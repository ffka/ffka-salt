{% set go_version = "1.10" %}

golang:
  pkg.installed:
    - fromrepo: stretch-backports

# manage the `go` symlink manually as golang-go is too opinionated about
# which go version to choose and cannot be reconfigured.
golang-go:
  pkg.purged

/usr/bin/go:
  file.symlink:
    - target: /usr/lib/go-{{ go_version }}/bin/go
    - force: True

golang-env:
  file.managed:
     - name: /etc/profile.d/go
     - contents:
         export GOPATH={{ pillar.get('golang:gopath', '/usr/local/go') }}
         export PATH=$PATH:$GOPATH/bin
