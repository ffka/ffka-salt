fastd:
  pkg.latest:
    - fromrepo: stretch-backports
    - refresh: True

/etc/fastd/fastdbl:
  git.latest:
    - name: https://github.com/ffka/fastdbl.git
    - target: /etc/fastd/fastdbl
    - rev: just-bl
    - branch: just-bl
    - force_fetch: True
    - force_reset: True
    - require:
      - pkg: fastd

include:
  - netdata.fastd
