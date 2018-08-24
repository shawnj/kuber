# Run Ansible Config

## Update Hosts file with dns records

- Need to bootstrap Python for CoreOS prior: https://github.com/defunctzombie/ansible-coreos-bootstrap

```
ansible-galaxy install defunctzombie.coreos-bootstrap -p ./roles
```