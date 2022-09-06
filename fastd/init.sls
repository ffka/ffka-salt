fastd:
  pkg.installed:
    - fromrepo: {{ grains['oscodename'] }}-backports

/etc/apt/preferences.d/backports-fastd:
  file.managed:
    - contents: |
        Package: fastd
        Pin: release n={{ grains['oscodename'] }}-backports
        Pin-Priority: 800

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
