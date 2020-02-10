#! /usr/bin/env/bash

cat > /root/appliance/management.appliance.reconf.sh <<EOF
export ETC_PATH=$ETC_PATH
export REPO_PATH=$REPO_PATH

export HTTP_PROXY=$HTTP_PROXY
export NO_PROXY=$NO_PROXY
export http_proxy=$http_proxy
export no_proxy=$no_proxy

export PLAYBOOK="$PLAYBOOK -v"

export MANAGEMENT_CONSUL_DATACENTER=$MANAGEMENT_CONSUL_DATACENTER
export MANAGEMENT_CONSUL_DNS_DOMAIN=$MANAGEMENT_CONSUL_DNS_DOMAIN
export MANAGEMENT_HTTP_PROXY=$MANAGEMENT_HTTP_PROXY
export MANAGEMENT_NO_PROXY=$MANAGEMENT_NO_PROXY

export OS_AUTH_URL=$OS_AUTH_URL
export OS_IDENTITY_API_VERSION=$OS_IDENTITY_API_VERSION
export OS_INTERFACE=$OS_INTERFACE
export OS_PASSWORD=$OS_PASSWORD
export OS_PROJECT_DOMAIN_ID=$OS_PROJECT_DOMAIN_ID
export OS_PROJECT_ID=$OS_PROJECT_ID
export OS_PROJECT_NAME=$OS_PROJECT_NAME
export OS_REGION_NAME=$OS_REGION_NAME
export OS_USERNAME=$OS_USERNAME
export OS_USER_DOMAIN_NAME=$OS_USER_DOMAIN_NAME

sed -i 's/exit 1/false/' $REPO_PATH/management.appliance.autoconf.sh

. $REPO_PATH/management.appliance.autoconf.sh
EOF

ansible-galaxy install -r $ETC_PATH/appliance.ansible_requirements.yml

# Sometimes cinder volumes are not linked against /dev/disk/by-id/
udevadm trigger

ansible-playbook -t os-ready $PLAYBOOK \
	-e@$ETC_PATH/appliance.variables.yml \
	|| exit 1

ansible-playbook -t master $PLAYBOOK \
	-e@$ETC_PATH/appliance.variables.yml \
	|| exit 1
