# Providers

| Name | Version |
|------|---------|
| openstack | n/a |

# Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| back\_net\_id | Backoffice network ID to use for the appliance | `string` | n/a | yes |
| consul\_datacenter | Datacenter name used by Consul agent | `string` | n/a | yes |
| consul\_dns\_domain | DNS domain used by Consul agent | `string` | n/a | yes |
| consul\_dns\_server | IP address to use for non-consul-managed domains | `string` | n/a | yes |
| consul\_encrypt | Consul shared secret for cluster communication | `string` | n/a | yes |
| default\_secgroup\_id | Default security group to use | `string` | n/a | yes |
| flavor\_id | Cloud flavor to use | `string` | n/a | yes |
| front\_net\_id | Network ID to use for the appliance | `string` | n/a | yes |
| git\_repo\_url | cloud-appliance-management repo | `string` | n/a | yes |
| image\_id | Operating system image to use | `string` | n/a | yes |
| os\_auth\_url | Cloud auth URL | `string` | n/a | yes |
| os\_password | Cloud password for some internal batches | `string` | n/a | yes |
| os\_region\_name | Cloud region name | `string` | n/a | yes |
| os\_username | loud username for some internal batches | `string` | n/a | yes |
| git\_repo\_checkout | branch/tag/commit to use | `string` | `"master"` | no |
| internet\_http\_no\_proxy | Proxy skiplist | `string` | `""` | no |
| internet\_http\_proxy\_url | HTTP proxy | `string` | `""` | no |
| ntp\_server | Remote NTP to use for sync | `string` | `""` | no |
| static\_hosts | JSON array of host:ip tuples | `string` | `""` | no |

# Outputs

No output.

