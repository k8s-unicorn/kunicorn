ntp:
  pkg:
    - installed
{% if grains['os_family'] == 'Debian' %}
  service.running:
    - watch:
      - pkg: ntp
{% elif grains['os_family'] == 'RedHat' %}
ntpd:
  service.running:
    - watch:
      - pkg: ntp
{% endif %}
