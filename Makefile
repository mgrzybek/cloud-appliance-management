###############################################################################
#
# Configuration
#

STACK	= management

GIT_REPO_URL=$(shell git remote get-url origin)
GIT_REPO_CHECKOUT=$(shell git rev-parse --abbrev-ref HEAD)

.PHONY: syntax # Testing YAML syntax
syntax:
	@which ansible-lint
	@find . -type f -name "*.playbook.yml" -exec ansible-lint {} \;

.PHONY: test # Testing YAML syntax, env variables and openstack connectivity
test: syntax
	@openstack stack list 1>/dev/null

.PHONY: status # Get some information about what is running
status:
	@echo "Projet: ${OS_PROJECT_NAME}"
	@echo "Cloud: ${OS_AUTH_URL}"
	@echo "#######################################################"
	@openstack network show ${MANAGEMENT_NET_ID} > /dev/null 2> /dev/null \
		&& echo network ${MANAGEMENT_NET_ID} is deployed \
		|| ( echo network ${MANAGEMENT_NET_ID} is not deployed ; exit 1 )
	@openstack stack show $(STACK) 2> /dev/null \
		|| ( echo $(STACK) is not deployed ; exit 1 )

.PHONY: help # This help message
help:
	@grep '^.PHONY: .* #' Makefile \
		| sed 's/\.PHONY: \(.*\) # \(.*\)/\1\t\2/' \
		| expand -t20 \
		| sort

###############################################################################
#
# Hosted services
#
.PHONY: management # Configure management services

		
management:
	@test ! -z ${MANAGEMENT_CONSUL_DNS_DOMAIN} \
		|| (echo MANAGEMENT_CONSUL_DNS_DOMAIN is empty ; exit 1)
	@test ! -z ${MANAGEMENT_CONSUL_DATACENTER} \
		|| (echo MANAGEMENT_CONSUL_DATACENTER is empty ; exit 1)
	@test ! -z ${MANAGEMENT_CONSUL_ENCRYPT} \
		|| (echo MANAGEMENT_CONSUL_ENCRYPT is empty ; exit 1)

	@openstack stack show $(STACK) \
	&& openstack stack update \
		\
		--parameter flavor=${MANAGEMENT_FLAVOR} \
		--parameter image_id=${MANAGEMENT_IMAGE_ID} \
		--parameter front_net_id=${MANAGEMENT_FRONT_NET_ID} \
		--parameter back_net_id=${MANAGEMENT_BACK_NET_ID} \
		--parameter default_secgroup_id=$(MANAGEMENT_SECGROUP_ID) \
		\
		--parameter os_username=$(MANAGEMENT_OS_USERNAME) \
		--parameter os_password=$(MANAGEMENT_OS_PASSWORD) \
		--parameter os_auth_url=$(MANAGEMENT_OS_AUTH_URL) \
		\
		--parameter internet_http_proxy_url=${MANAGEMENT_HTTP_PROXY} \
		--parameter internet_http_no_proxy=${MANAGEMENT_NO_PROXY} \
		\
		--parameter git_repo_checkout=${GIT_REPO_CHECKOUT} \
		--parameter git_repo_url=${GIT_REPO_URL} \
		--parameter git_repo_username=${GIT_REPO_USERNAME} \
		--parameter git_repo_password=${GIT_REPO_PASSWORD} \
		\
		--parameter consul_dns_domain=${MANAGEMENT_CONSUL_DNS_DOMAIN} \
		--parameter consul_datacenter=${MANAGEMENT_CONSUL_DATACENTER} \
		\
		--template ${PWD}/management.appliance.heat.yml \
		--wait \
		--timeout 60 \
		--converge \
		\
		$(STACK) \
	|| openstack stack create \
		\
		--parameter flavor=${MANAGEMENT_FLAVOR} \
		--parameter image_id=${MANAGEMENT_IMAGE_ID} \
		--parameter front_net_id=${MANAGEMENT_FRONT_NET_ID} \
		--parameter back_net_id=${MANAGEMENT_BACK_NET_ID} \
		--parameter default_secgroup_id=$(MANAGEMENT_SECGROUP_ID) \
		\
		--parameter os_username=$(MANAGEMENT_OS_USERNAME) \
		--parameter os_password=$(MANAGEMENT_OS_PASSWORD) \
		--parameter os_auth_url=$(MANAGEMENT_OS_AUTH_URL) \
		\
		--parameter internet_http_proxy_url=${MANAGEMENT_HTTP_PROXY} \
		--parameter internet_http_no_proxy=${MANAGEMENT_NO_PROXY} \
		--parameter static_hosts=$(MANAGEMENT_STATIC_HOSTS) \
		\
		--parameter git_repo_checkout=${GIT_REPO_CHECKOUT} \
		--parameter git_repo_url=${GIT_REPO_URL} \
		--parameter git_repo_username=${GIT_REPO_USERNAME} \
		--parameter git_repo_password=${GIT_REPO_PASSWORD} \
		\
		--parameter consul_dns_domain=${MANAGEMENT_CONSUL_DNS_DOMAIN} \
		--parameter consul_datacenter=${MANAGEMENT_CONSUL_DATACENTER} \
		--parameter consul_encrypt=${MANAGEMENT_CONSUL_ENCRYPT} \
		\
		--template ${PWD}/management.appliance.heat.yml \
		--wait \
		--timeout 60 \
		\
		$(STACK)

###############################################################################
#
# Maintenance
#

# Clean
.PHONY: clean # Destroy the managenemt appliances
clean:
	@openstack stack list | fgrep -q $(STACK) \
		&& openstack stack delete --wait --yes $(STACK) \
		|| echo

# Rebuild
.PHONY: rebuild # Rebuild the management appliance
rebuild:
	@openstack server rebuild --wait $(STACK)

.PHONY: all # Deploy the management appliances
all: management
	@echo
