dnf-automatic:
  pkg.installed

/etc/dnf/automatic.conf:
  init.options_present:
    - separator: '='
    - sections:
      commands:
        apply_updates: yes

dnf-automatic.timer:
  service:
    - running
    - enabled

