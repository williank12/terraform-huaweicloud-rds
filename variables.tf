variable "name" {
  description = "Specifies the name of the RDS instance"
  type        = string
  nullable    = false
}

variable "name_postfix" {
  description = "Specifies the name postfix of the RDS instance"
  type        = string
  default     = null
}

variable "region" {
  description = "Specifies the region in which to create the resource, if omitted, the provider-level region will be used"
  type        = string
  default     = null
}

variable "availability_zones" {
  description = "Specifies the AZ name, if omitted, AZ calculates automatically"
  type        = list(string)
  default     = []
  validation {
    condition     = length(var.availability_zones) <= 2
    error_message = "Specify one availability zone for single, two for primary/standby or keep it empty to do it automatically."
  }
}

variable "availability_zone_replica" {
  description = "Specifies the AZ name for RDS Read Replica Instance, if omitted, AZ calculates automatically"
  type        = list(string)
  default     = []
  validation {
    condition     = length(var.availability_zone_replica) <= 1
    error_message = "Specify one availability zone for RDS Read Replica Instance or keep it empty."
  }
}

variable "vpc_id" {
  description = "Specifies the VPC ID"
  type        = string
  nullable    = false
}

variable "subnet_id" {
  description = "Specifies the network id of a subnet"
  type        = string
  nullable    = false
}

variable "security_group_id" {
  description = "Specifies the security group which the RDS DB instance belongs to"
  type        = string
  nullable    = false
}

variable "instance_mode" {
  description = "Specifies the mode of db instance - 'single' or 'ha'"
  type        = string
  default     = "single"
  validation {
    condition     = contains(["single", "ha"], var.instance_mode)
    error_message = "Valid values for instance mode are 'single' or 'ha'."
  }
}

variable "ha_replication_mode" {
  description = "Specifies the replication mode for the standby DB instance"
  type        = string
  default     = "async"
  validation {
    condition     = contains(["async", "sync"], var.ha_replication_mode)
    error_message = "Valid values for replication mode are 'async' or 'sync'."
  }
}

variable "instance_type" {
  description = <<DES
  Specifies the parameters of DB instance to calculate flavor automatically, if flavors.[type] is omitted

  * `vcpus` - Specifies the number of vCPUs in the RDS flavor;
  * `memory` - Specifies the memory size(GB) in the RDS flavor;
  * `group_type` - Specifies the performance specification,
    the valid values are as follows:

    * `normal`: General enhanced;
    * `normal2`: General enhanced type II;
    * `armFlavors`: KunPeng general enhancement;
    * `dedicatedNormal`: (dedicatedNormalLocalssd): Dedicated for x86;
    * `armLocalssd`: KunPeng general type;
    * `normalLocalssd`: x86 general type;
    * `general`: General type;
    * `dedicated`: only supported by cloud disk SSD;
    * `rapid`: only supported by ultra-fast SSDs;
    * `bigmem`: Large memory type.
  DES
  type = object({
    vcpus      = optional(number, null)
    memory     = optional(number, null)
    group_type = optional(string, "general")
  })
  default = {
    vcpus      = 2
    memory     = 4
    group_type = "general"
  }
}

variable "instance_replica_type" {
  description = <<DES
  Specifies the parameters of RDS Read Replica Instance to calculate flavor automatically, if flavors.replica is omitted

  * `vcpus` - Specifies the number of vCPUs in the RDS flavor;
  * `memory` - Specifies the memory size(GB) in the RDS flavor;
  * `group_type` - Specifies the performance specification,
    the valid values are as follows:

    * `normal`: General enhanced;
    * `normal2`: General enhanced type II;
    * `armFlavors`: KunPeng general enhancement;
    * `dedicatedNormal`: (dedicatedNormalLocalssd): Dedicated for x86;
    * `armLocalssd`: KunPeng general type;
    * `normalLocalssd`: x86 general type;
    * `general`: General type;
    * `dedicated`: only supported by cloud disk SSD;
    * `rapid`: only supported by ultra-fast SSDs;
    * `bigmem`: Large memory type.
  DES
  type = object({
    vcpus      = optional(number, null)
    memory     = optional(number, null)
    group_type = optional(string, "general")
  })
  default = {
    vcpus      = 2
    memory     = 4
    group_type = "general"
  }
}

variable "mysql_version" {
  description = "Indicates the mysqlql version"
  type        = string
  default     = "14"
}

variable "replica" {
  description = "Enabler for read replica instance"
  type        = bool
  default     = false
}

variable "flavors" {
  description = <<DES
  Specifies the specification code of instance flavor.
  *Services will be interrupted for 5 to 10 minutes when you change RDS instance flavor.*
  If flavor is omitted, it'll calculated automatically.

  https://support.huaweicloud.com/intl/en-us/productdesc-rds/rds_01_0035.html
  DES
  type = object({
    ha      = optional(string, null)
    single  = optional(string, null)
    replica = optional(string, null)
  })
  default = {
    ha      = "rds.pg.n1.large.2.ha"
    single  = "rds.pg.n1.large.2"
    replica = "rds.pg.n1.large.2.rr"
  }
}

variable "volume" {
  description = <<DES
  Specifies the volume information:

  * `size` - Specifies the volume size. Its value range is from 40 GB to 4000 GB.
    The value must be a multiple of 10 and greater than the original size.
  * `type` - Specifies the volume type. Its value can be any of the following and is case-sensitive:
    * `ULTRAHIGH`: SSD storage;
    * `LOCALSSD`: local SSD storage
    * `CLOUDSSD`: cloud SSD storage, this storage type is supported only with general-purpose and dedicated DB instances;
    * `ESSD`: extreme SSD storage.
  DES
  type = object({
    size               = optional(number, 50)
    type               = optional(string, "CLOUDSSD")
    disk_encryption_id = optional(string, null)
  })
  default = {}
}

variable "password" {
  description = "Specifies the database password"
  type        = string
  sensitive   = true
  default     = "VerY_5tr0nG-Pa55w0R^d"
  validation {
    condition     = length(var.password) >= 8 && length(var.password) <= 32
    error_message = "The value must be 8 to 32 characters in length, including uppercase and lowercase letters, digits, and the following special characters: ~!@#%^*-_=+?"
  }
}

variable "port" {
  description = "Specifies the database port"
  type        = number
  default     = 5432
  validation {
    condition     = var.port >= 2100 && var.port <= 9500
    error_message = "The MySQL database port ranges from 2100 to 9500"
  }
}

variable "time_zone" {
  description = "Specifies the UTC time zone"
  type        = string
  default     = null
}

variable "databases" {
  description = <<DES
  Specifies Database resource within HuaweiCloud RDS Postgres instance:
  * `key` - specifies the database name;
  * `character_set` - specifies the character set used by the database;
  * `description` - specifies the database description.
  DES
  type = map(object({
    character_set = optional(string, "UTF8")
    description   = optional(string, null)
  }))
  default = {}
}

variable "parameter_group_values" {
  description = "Parameter group values key/value pairs defined by users based on the default parameter groups"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Specifies the key/value pairs to associate with the Object Storage"
  type        = map(string)
  default     = {}
}
