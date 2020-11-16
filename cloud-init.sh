#!/bin/bash
set -x

# Proxy
export HTTPS_PROXY=${internet_http_proxy_url}
export HTTP_PROXY=${internet_http_proxy_url}
export NO_PROXY=${internet_http_no_proxy},127.0.0.1,localhost,0.0.0.0,${backoffice_ip_address}
export https_proxy=${internet_http_proxy_url}
export http_proxy=${internet_http_proxy_url}
export no_proxy=${internet_http_no_proxy},127.0.0.1,localhost,0.0.0.0,${backoffice_ip_address}

# Install required packages to start git-ops-based auto-configuratiom
if which yum > /dev/null 2>&1 ; then
	sed -i 's/gpgcheck=1/gpgcheck=1\nproxy=_none_/g' /etc/yum.repos.d/centos.repo
	sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/epel.repo

	if [ ! -z "$HTTP_PROXY" ] ; then
		grep -q proxy= /etc/yum.conf || echo "proxy=$HTTP_PROXY" >> /etc/yum.conf
	fi

	test -f /etc/yum.repos.d/centos.repo && sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/centos.repo

	yum install --assumeyes \
		$(yum search centos-release-openstack- | awk '/centos-release-openstack-/ {print $1}' | sort | tail -n1)
	if [ $? -ne 0 ] ; then
		send_logs
		exit 1
	fi

	yum install --assumeyes \
		ansible git jq \
		python3-swiftclient python3-openstackclient \
		unzip > /dev/null
	if [ $? -ne 0 ] ; then
		send_logs
		exit 1
	fi
else
	apt update > /dev/null
	apt -y install \
		ansible git jq \
		python3-swiftclient python3-openstackclient \
		unzip \
		libgpgme11 > /dev/null
	if [ $? -ne 0 ] ; then
		send_logs
		exit 1
	fi
fi

# DNS: Populate /etc/hosts
if [ ! -z "${static_hosts}" ] ; then
	echo ${static_hosts} > /tmp/static_hosts
	cat /tmp/static_hosts \
	| perl -pe 's/\[|\]|{|}//g' \
	|  tr ',' '\n' \
	| awk -F: '{print $2,$1}' \
	| awk '{print $1,$2}' \
	>> /etc/hosts
fi

# Configure ansible to work without an entire environment set
sed -i 's/~/\/root/' /etc/ansible/ansible.cfg
sed -i 's/^#remote_tmp/remote_tmp/' /etc/ansible/ansible.cfg
sed -i 's/^#local_tmp/local_tmp/' /etc/ansible/ansible.cfg

# Create local facts folder
mkdir -p /etc/ansible/facts.d

# Clone the bootstrap git repository
export REPO_PATH=/root/appliance
export ETC_PATH=$REPO_PATH/etc
export PLAYBOOK=$REPO_PATH/management.appliance.playbook.yml

## Set the Openstack credentials
export OS_AUTH_URL="${os_auth_url}"
export OS_PROJECT_ID=$(awk -F'"' '/project_id/ {print $4}' /run/cloud-init/instance-data.json)
export OS_USER_DOMAIN_NAME="Default"
export OS_USERNAME="${os_username}"
export OS_PASSWORD="${os_password}"
export OS_REGION_NAME="${os_region_name}"
export OS_INTERFACE=public
export OS_IDENTITY_API_VERSION=3

# Swift container
#export VAULT_CONTAINER=$vault_container
export VAULT_CONTAINER=vault

# Set Syslog remote endpoint
export SYSLOG_PROTOCOL="${syslog_protocol}"
export SYSLOG_LOG_FORMAT="${syslog_log_format}"
export SYSLOG_HOSTNAME="${syslog_hostname}"
export SYSLOG_PORT="${syslog_port}"

# Set Consul variables
export CONSUL_DNS_DOMAIN="${consul_dns_domain}"
export CONSUL_DNS_SERVER="${consul_dns_server}"
export CONSUL_DATACENTER="${consul_datacenter}"
export CONSUL_BOOTSTRAP_EXPECT=1
export CONSUL_ENCRYPT="${consul_encrypt}"
export BACK_IP="${backoffice_ip_address}"

# Traefik variables
export TRAEFIK_CONSUL_PREFIX="${traefik_consul_prefix}"

# NTP service
export NTP_SERVER="${ntp_server}"

# Autoconf the appliance
if [ ! -z "${git_repo_username}${git_repo_password}" ] ; then
	auth_git_repo_url=$(echo ${git_repo_url} | awk -F// -v user=${git_repo_username}  -v password=${git_repo_password} '{print $1"//"user":"password"@"$2}')
	git clone -b ${git_repo_checkout} $auth_git_repo_url $REPO_PATH || exit 1
else
	git clone -b ${git_repo_checkout} ${git_repo_url} $REPO_PATH || exit 1
fi

. $REPO_PATH/management.appliance.autoconf.sh

# Stop secure shell
#systemctl stop ssh
#systemctl disable ssh

