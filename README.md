# Unidad 2 - Docker

### Start

Vagrant

`vagrant up --provision`

Docker containers

- `vagrant ssh`
- `cd /tmp/docker`
- `sudo docker-compose up`

Seed database (desde el container de mongo)

- `sudo docker exec -it utn-devops-db /bin/bash`
- `cd /tmp/seed`
- `bash seed.sh`

### Shutdown

`vagrant halt`

### Destroy

`vagrant destroy`

### Provisioning

It will run when calling `vagrant up` the first time

#### Re-run provisioning

`vagrant provision` or `vagrant up --provision`
