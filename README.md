# Huawei Cloud Relational Database Service PostgreSQL

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4 |
| <a name="requirement_huaweicloud"></a> [huaweicloud](#requirement\_huaweicloud) | ~>1.47 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_huaweicloud"></a> [huaweicloud](#provider\_huaweicloud) | ~>1.47 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [huaweicloud_rds_database.main](https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/rds_database) | resource |
| [huaweicloud_rds_instance.main](https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/rds_instance) | resource |
| [huaweicloud_rds_parametergroup.main](https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/rds_parametergroup) | resource |
| [huaweicloud_rds_read_replica_instance.replica](https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/rds_read_replica_instance) | resource |
| [huaweicloud_availability_zones.zones](https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/data-sources/availability_zones) | data source |
| [huaweicloud_rds_flavors.flavor](https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/data-sources/rds_flavors) | data source |
| [huaweicloud_rds_flavors.flavor_replica](https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/data-sources/rds_flavors) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone_replica"></a> [availability\_zone\_replica](#input\_availability\_zone\_replica) | Specifies the AZ name for RDS Read Replica Instance, if omitted, AZ calculates automatically | `list(string)` | `[]` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Specifies the AZ name, if omitted, AZ calculates automatically | `list(string)` | `[]` | no |
| <a name="input_databases"></a> [databases](#input\_databases) | Specifies Database resource within HuaweiCloud RDS Postgres instance:<br>  * `key` - specifies the database name;<br>  * `character_set` - specifies the character set used by the database;<br>  * `description` - specifies the database description. | <pre>map(object({<br>    character_set = optional(string, "UTF8")<br>    description   = optional(string, null)<br>  }))</pre> | `{}` | no |
| <a name="input_flavors"></a> [flavors](#input\_flavors) | Specifies the specification code of instance flavor.<br>  *Services will be interrupted for 5 to 10 minutes when you change RDS instance flavor.*<br>  If flavor is omitted, it'll calculated automatically.<br><br>  https://support.huaweicloud.com/intl/en-us/productdesc-rds/rds_01_0035.html | <pre>object({<br>    ha      = optional(string, null)<br>    single  = optional(string, null)<br>    replica = optional(string, null)<br>  })</pre> | <pre>{<br>  "ha": "rds.pg.n1.large.2.ha",<br>  "replica": "rds.pg.n1.large.2.rr",<br>  "single": "rds.pg.n1.large.2"<br>}</pre> | no |
| <a name="input_ha_replication_mode"></a> [ha\_replication\_mode](#input\_ha\_replication\_mode) | Specifies the replication mode for the standby DB instance | `string` | `"async"` | no |
| <a name="input_instance_mode"></a> [instance\_mode](#input\_instance\_mode) | Specifies the mode of db instance - 'single' or 'ha' | `string` | `"single"` | no |
| <a name="input_instance_replica_type"></a> [instance\_replica\_type](#input\_instance\_replica\_type) | Specifies the parameters of RDS Read Replica Instance to calculate flavor automatically, if flavors.replica is omitted<br><br>  * `vcpus` - Specifies the number of vCPUs in the RDS flavor;<br>  * `memory` - Specifies the memory size(GB) in the RDS flavor;<br>  * `group_type` - Specifies the performance specification,<br>    the valid values are as follows:<br><br>    * `normal`: General enhanced;<br>    * `normal2`: General enhanced type II;<br>    * `armFlavors`: KunPeng general enhancement;<br>    * `dedicatedNormal`: (dedicatedNormalLocalssd): Dedicated for x86;<br>    * `armLocalssd`: KunPeng general type;<br>    * `normalLocalssd`: x86 general type;<br>    * `general`: General type;<br>    * `dedicated`: only supported by cloud disk SSD;<br>    * `rapid`: only supported by ultra-fast SSDs;<br>    * `bigmem`: Large memory type. | <pre>object({<br>    vcpus      = optional(number, null)<br>    memory     = optional(number, null)<br>    group_type = optional(string, "general")<br>  })</pre> | <pre>{<br>  "group_type": "general",<br>  "memory": 4,<br>  "vcpus": 2<br>}</pre> | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Specifies the parameters of DB instance to calculate flavor automatically, if flavors.[type] is omitted<br><br>  * `vcpus` - Specifies the number of vCPUs in the RDS flavor;<br>  * `memory` - Specifies the memory size(GB) in the RDS flavor;<br>  * `group_type` - Specifies the performance specification,<br>    the valid values are as follows:<br><br>    * `normal`: General enhanced;<br>    * `normal2`: General enhanced type II;<br>    * `armFlavors`: KunPeng general enhancement;<br>    * `dedicatedNormal`: (dedicatedNormalLocalssd): Dedicated for x86;<br>    * `armLocalssd`: KunPeng general type;<br>    * `normalLocalssd`: x86 general type;<br>    * `general`: General type;<br>    * `dedicated`: only supported by cloud disk SSD;<br>    * `rapid`: only supported by ultra-fast SSDs;<br>    * `bigmem`: Large memory type. | <pre>object({<br>    vcpus      = optional(number, null)<br>    memory     = optional(number, null)<br>    group_type = optional(string, "general")<br>  })</pre> | <pre>{<br>  "group_type": "general",<br>  "memory": 4,<br>  "vcpus": 2<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Specifies the name of the RDS instance | `string` | n/a | yes |
| <a name="input_name_postfix"></a> [name\_postfix](#input\_name\_postfix) | Specifies the name postfix of the RDS instance | `string` | `null` | no |
| <a name="input_parameter_group_values"></a> [parameter\_group\_values](#input\_parameter\_group\_values) | Parameter group values key/value pairs defined by users based on the default parameter groups | `map(string)` | `{}` | no |
| <a name="input_password"></a> [password](#input\_password) | Specifies the database password | `string` | `"VerY_5tr0nG-Pa55w0R^d"` | no |
| <a name="input_port"></a> [port](#input\_port) | Specifies the database port | `number` | `5432` | no |
| <a name="input_postgres_version"></a> [postgres\_version](#input\_postgres\_version) | Indicates the postgresql version | `string` | `"14"` | no |
| <a name="input_region"></a> [region](#input\_region) | Specifies the region in which to create the resource, if omitted, the provider-level region will be used | `string` | `null` | no |
| <a name="input_replica"></a> [replica](#input\_replica) | Enabler for read replica instance | `bool` | `false` | no |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | Specifies the security group which the RDS DB instance belongs to | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Specifies the network id of a subnet | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Specifies the key/value pairs to associate with the Object Storage | `map(string)` | `{}` | no |
| <a name="input_time_zone"></a> [time\_zone](#input\_time\_zone) | Specifies the UTC time zone | `string` | `null` | no |
| <a name="input_volume"></a> [volume](#input\_volume) | Specifies the volume information:<br><br>  * `size` - Specifies the volume size. Its value range is from 40 GB to 4000 GB.<br>    The value must be a multiple of 10 and greater than the original size.<br>  * `type` - Specifies the volume type. Its value can be any of the following and is case-sensitive:<br>    * `ULTRAHIGH`: SSD storage;<br>    * `LOCALSSD`: local SSD storage<br>    * `CLOUDSSD`: cloud SSD storage, this storage type is supported only with general-purpose and dedicated DB instances;<br>    * `ESSD`: extreme SSD storage. | <pre>object({<br>    size               = optional(number, 50)<br>    type               = optional(string, "CLOUDSSD")<br>    disk_encryption_id = optional(string, null)<br>  })</pre> | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Specifies the VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | RDS PostgreSQL instance ID |
| <a name="output_password"></a> [password](#output\_password) | RDS PostgreSQL Password |
| <a name="output_port"></a> [port](#output\_port) | RDS PostgreSQL instance port |
| <a name="output_private_ips"></a> [private\_ips](#output\_private\_ips) | RDS PostgreSQL instance private IPs |
| <a name="output_public_ips"></a> [public\_ips](#output\_public\_ips) | RDS PostgreSQL instance public IPs |
| <a name="output_user_name"></a> [user\_name](#output\_user\_name) | RDS PostgreSQL User name |
<!-- END_TF_DOCS -->