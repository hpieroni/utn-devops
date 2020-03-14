# Unidad 4 - Jenkins

### Start

**Vagrant**

`vagrant up --provision`

**Puppet**

- `sudo puppet agent -t --debug`
- `sudo puppet cert sign utn-devops.localhost`
- `sudo puppet agent -t --debug`
- `sudo cat /var/lib/jenkins/secrets/initialAdminPassword` -> to see the password to unlock Jenkins
- Go to `http://127.0.0.1:8082/` and configure Jenkins

### Shutdown

`vagrant halt`

### Destroy

`vagrant destroy`

### Provisioning

It will run when calling `vagrant up` the first time

#### Re-run provisioning

`vagrant provision` or `vagrant up --provision`
