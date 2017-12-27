include:
  - .debian-auto-upgrades

pkg-core-debian-family:
  pkg.installed:
    - names:
      - apt-transport-https
      - python-apt
# Ubuntu installs netcat-openbsd by default, but on GCE/Debian netcat-traditional is installed.
# They behave slightly differently.
# For sanity, we try to make sure we have the same netcat on all OSes (#15166)
      - netcat-traditional
      - nfs-common
