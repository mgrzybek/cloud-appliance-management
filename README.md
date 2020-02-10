# cloud-appliance-management

## Description

Deploy management appliances using Openstack HEAT. The provided services are 
part of the Haschcorp tools stack.

## Usage

You must source your Openstack credentials first. Then, some variables need to 
be set.

```bash
export GIT_REPO_URL=https://github.com/mgrzybek/cloud-appliance-management

# Metrics management
export MANAGEMENT_FLAVOR=
export MANAGEMENT_IMAGE_ID=
export MANAGEMENT_NET_ID=
export MANAGEMENT_SECGROUP_ID=

export MANAGEMENT_HTTP_PROXY=
export MANAGEMENT_NO_PROXY=

export MANAGEMENT_CONSUL_DNS_DOMAIN=
export MANAGEMENT_CONSUL_DATACENTER=
```

Control the deployments

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

