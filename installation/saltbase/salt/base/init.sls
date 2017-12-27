include:
{% if grains['os_family'] == 'Debian' %}
  - .debian
{% elif grains['os_family'] == 'RedHat' %}
  - .redhat
{% endif %}
  - .ntp

pkg-core:
  pkg.installed:
    - names:
      - curl
      - ebtables
      - socat
      - python
      - git


# Fix ARP cache issues by setting net.ipv4.neigh.default.gc_thresh1=0
net.ipv4.neigh.default.gc_thresh1:
  sysctl.present:
    - value: 0