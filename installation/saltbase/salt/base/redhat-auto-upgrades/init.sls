include:
{% if grains['os'] == 'Fedora' %}
  - .fedora
{% elif grains['os'] == 'Centos' %}
  - .centos
{% endif %}
