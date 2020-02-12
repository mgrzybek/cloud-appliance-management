# cloud-appliance-management

## Description

Deploy management appliances using Openstack HEAT. The provided services are 
part of the Hashicorp tools stack.

## Usage

You must source your Openstack credentials first. Then, some variables need to 
be set.

```bash
# Variables management
export MANAGEMENT_FLAVOR=CO1.1
export MANAGEMENT_IMAGE_ID=ubuntu18.04_server
export MANAGEMENT_NET_ID=adm-front
export MANAGEMENT_SECGROUP_ID=default

export MANAGEMENT_HTTP_PROXY=
export MANAGEMENT_NO_PROXY=

export MANAGEMENT_CONSUL_DNS_DOMAIN=poc
export MANAGEMENT_CONSUL_DATACENTER=$(echo $OS_AUTH_URL | perl -ne '/\/(\w+)/ && print $1')
export MANAGEMENT_CONSUL_ENCRYPT=$(consul keygen)
```

Control the deployments.

```bash
# Get help
make help

# Testing
make syntax
make test
make status

# Deployements
make all

# Cleanups
make clean

# Rebuilds
make rebuild
```
