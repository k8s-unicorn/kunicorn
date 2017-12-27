yum-cron:
  pkg:
    - installed
  service.running:
    - enable: true
    - watch:
      - pkg: yum-cron