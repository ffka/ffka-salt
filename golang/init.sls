{% set go_version = "1.10" %}

golang:
  pkg.installed:
    {% if salt['grains.get']('osfinger') == 'Debian-9' %}
    - fromrepo: stretch-backports
    {% else %}
    []
    {% endif %}

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
