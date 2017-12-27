# SaltStack configuration

This is the root of the SaltStack configuration for Kubernetes. A high
level overview for the Kubernetes SaltStack configuration can be found [in the docs tree.](https://kubernetes.io/docs/admin/salt.md)

This SaltStack configuration currently applies to default
configurations for Ubuntu and Centos. (That doesn't mean it can't be made to apply to an
arbitrary configuration, but those are only the in-tree OS/IaaS
combinations supported today.)
the documentation in this tree uses this same shorthand for convenience.

See more:
* [pillar](pillar/)
* [reactor](reactor/)
* [salt](salt/)


Installation scripts are based on kubernetes official salt installation scrips and customized for offline installation.