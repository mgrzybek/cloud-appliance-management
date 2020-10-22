################################################################################
# Cloud
#

variable "image_name" {
  type        = string
  description = "Operating system image to use"
}

variable "front_net_id" {
  type        = string
  description = "Network ID to use for the appliance"

  validation {
    condition     = can(regex("[[:alnum:]]{8}-[[:alnum:]]{4}-[[:alnum:]]{4}-[[:alnum:]]{4}-[[:alnum:]]{12}", var.front_net_id))
    error_message = "This must be a valid netowrk ID"
  }
}

variable "back_net_id" {
  type        = string
  description = "Backoffice network ID to use for the appliance"
  validation {
    condition     = can(regex("[[:alnum:]]{8}-[[:alnum:]]{4}-[[:alnum:]]{4}-[[:alnum:]]{4}-[[:alnum:]]{12}", var.front_net_id))
    error_message = "This must be a valid netowrk ID"
  }
}

variable "os_username" {
  type        = string
  description = "Cloud username for some internal batches"
}

variable "os_password" {
  type        = string
  description = "Cloud password for some internal batches"
}

variable "os_auth_url" {
  type        = string
  description = "Cloud auth URL"
}

variable "os_region_name" {
  type        = string
  description = "Cloud region name"
}

variable "git_repo_username" {
  type        = string
  description = "git username"
  default     = ""
}

variable "git_repo_password" {
  type        = string
  description = "git password"
  default     = ""
}

variable "git_repo_url" {
  type        = string
  description = "cloud-appliance-management repo"
  default     = "https://github.com/mgrzybek/cloud-appliance-management"
}

variable "git_repo_checkout" {
  type        = string
  description = "branch/tag/commit to use"
  default     = "terraform"
}

variable "default_secgroup_id" {
  type        = string
  description = "Default security group to use"
  validation {
    condition     = can(regex("[[:alnum:]]{8}-[[:alnum:]]{4}-[[:alnum:]]{4}-[[:alnum:]]{4}-[[:alnum:]]{12}", var.front_net_id))
    error_message = "This must be a valid secgroup ID"
  }
}

variable "internet_http_proxy_url" {
  type        = string
  description = "HTTP proxy"
  default     = ""
}

variable "internet_http_no_proxy" {
  type        = string
  description = "Proxy skiplist"
  default     = ""
}

variable "ntp_server" {
  type        = string
  description = "Remote NTP to use for sync"
  default     = ""
}

variable "static_hosts" {
  type        = string
  description = "JSON array of host:ip tuples"
  default     = ""
}

variable "flavor_name" {
  type        = string
  description = "Cloud flavor to use"
}

# Sending logs to a remote Graylog endpoint
variable "syslog_protocol" {
  type        = string
  description = "Protocol used to send logs: udp, tcp or http"
  default     = "udp"

  validation {
    condition     = var.syslog_protocol == "udp" || var.syslog_protocol == "tcp" || var.syslog_protocol == "http"
    error_message = "The log management protocol must be 'udp', 'tcp' or 'http'"
  }
}

variable "syslog_log_format" {
  type        = string
  description = "Log format used to send logs: gelf or syslog"
  default     = "gelf"

  validation {
    condition     = var.syslog_log_format == "gelf" || var.syslog_log_format == "syslog"
    error_message = "The log format must be 'gelf' or 'syslog'"
  }
}

variable "syslog_hostname" {
  type        = string
  description = "Hostname or address of the remote log management endpoint"
}

variable "syslog_port" {
  type        = number
  description = "Port number of the remote log management endpoint"
  default     = 12201
}


variable "logs_container" {
  type        = string
  description = "Swift container to use for cloud-init logs"
  default     = "logs"
}

##############################################################################
# Consul
#

variable "consul_dns_domain" {
  type        = string
  description = "DNS domain used by Consul agent"
}

variable "consul_datacenter" {
  type        = string
  description = "Datacenter name used by Consul agent"
}

variable "consul_encrypt" {
  type        = string
  description = "Consul shared secret for cluster communication"
}

variable "consul_dns_server" {
  type        = string
  description = "IP address to use for non-consul-managed domains"
}

variable "allowed_inbound_security_group_ids" {
  description = "A list of security group IDs that will be allowed to connect to Consul"
  type        = list(string)
  default     = []
}

variable "allowed_inbound_security_group_count" {
  description = "The number of entries in var.allowed_inbound_security_group_ids. Ideally, this value could be computed dynamically, but we pass this variable to a Terraform resource's 'count' property and Terraform requires that 'count' be computed with literals or data sources only."
  type        = number
  default     = 0
}

variable "consul_server_rpc_port" {
  description = "The port used by servers to handle incoming requests from other agents."
  type        = number
  default     = 8300
}

variable "consul_cli_rpc_port" {
  description = "The port used by all agents to handle RPC from the CLI."
  type        = number
  default     = 8400
}

variable "consul_serf_lan_port" {
  description = "The port used to handle gossip in the LAN. Required by all agents."
  type        = number
  default     = 8301
}

variable "serf_wan_port" {
  description = "The port used by servers to gossip over the WAN to other servers."
  type        = number
  default     = 8302
}

variable "consul_http_api_port" {
  description = "The port used by clients to talk to the HTTP API"
  type        = number
  default     = 8500
}

variable "consul_dns_port" {
  description = "The port used to resolve DNS queries."
  type        = number
  default     = 8600
}

##############################################################################
# Nomad
#

variable "nomad_http_port" {
  description = "The port to use for HTTP"
  type        = number
  default     = 4646
}

variable "nomad_rpc_port" {
  description = "The port to use for RPC"
  type        = number
  default     = 4647
}

variable "nomad_serf_port" {
  description = "The port to use for Serf"
  type        = number
  default     = 4648
}

##############################################################################
# Vault
#

variable "vault_http_port" {
  description = "The port to use for HTTP"
  type        = number
  default     = 8200
}

##############################################################################
# Management
#

variable "traefik_consul_prefix" {
  type        = string
  description = "Prefix used in services metadata to manage traefik's attributes"
  default     = "admin"
}

