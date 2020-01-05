saltstack-repo:
  pkgrepo.managed:
    - humanname: saltstack
    {% if salt['grains.get']('oscodename') == 'stretch' %}
    - name: deb http://repo.saltstack.com/apt/debian/{{ salt['grains.get']('osmajorrelease') }}/amd64/latest {{ salt['grains.get']('oscodename') }} main
    - key_url: https://repo.saltstack.com/apt/debian/{{ salt['grains.get']('osmajorrelease') }}/amd64/latest/SALTSTACK-GPG-KEY.pub
    {% else %}
    - name: deb http://repo.saltstack.com/py3/debian/{{ salt['grains.get']('osmajorrelease') }}/amd64/latest {{ salt['grains.get']('oscodename') }} main
    - key_url: https://repo.saltstack.com/py3/debian/{{ salt['grains.get']('osmajorrelease') }}/amd64/latest/SALTSTACK-GPG-KEY.pub
    {% endif %}
    - clean_file: True
    - file: /etc/apt/sources.list.d/saltstack.list

/etc/salt/minion:
  file.absent

/etc/salt/minion_id:
  file.managed:
    - contents: {{ salt['grains.get']('fqdn') }}
    - user: root
    - group: root
    - mode: 644
    - onchanges:
      - pkg: salt-minion

/etc/salt/minion.d:
  file.recurse:
    - template: jinja
    - source: salt://salt/files/minion.d
    - clean: False # salt minion will create config files (starting with a _) which shold not be deleted

salt-minion:
  pkg.installed:
    - fromrepo: {{ salt['grains.get']('oscodename') }}
    - require:
      - pkgrepo: saltstack-repo
  service.running:
    - enable: True
    - watch:
      - file: /etc/salt/minion.d
      - file: /etc/salt/minion_id
      - file: /etc/salt/minion
