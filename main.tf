data "huaweicloud_availability_zones" "zones" {
  region = var.region
}


data "huaweicloud_rds_flavors" "flavor" {
  db_type       = "PostgreSQL"
  region        = var.region
  db_version    = var.postgres_version
  instance_mode = var.instance_mode
  vcpus         = var.instance_type.vcpus
  memory        = var.instance_type.memory
  group_type    = var.instance_type.group_type
}


data "huaweicloud_rds_flavors" "flavor_replica" {
  db_type       = "PostgreSQL"
  region        = var.region
  db_version    = var.postgres_version
  instance_mode = "replica"
  vcpus         = var.instance_type.vcpus
  memory        = var.instance_type.memory
  group_type    = var.instance_type.group_type
}


locals {
  name         = var.name_postfix == null ? format("%s-rds", var.name) : format("%s-rds-%s", var.name, var.name_postfix)
  name_replica = var.name_postfix == null ? format("%s-rds-rr", var.name) : format("%s-rds-rr-%s", var.name, var.name_postfix)
  az_number    = var.instance_mode == "single" ? 1 : 2

  ##
  # If the flavor doesn't set explicitly via variable, it will calculated automatically
  ##
  flavor_explicit = var.instance_mode == "single" ? var.flavors.single : var.flavors.ha
  flavor          = local.flavor_explicit == null ? data.huaweicloud_rds_flavors.flavor.flavors[0].name : local.flavor_explicit
  flavor_replica  = var.flavors.replica == null ? data.huaweicloud_rds_flavors.flavor_replica.flavors[0].name : var.flavors.replica

  ##
  # Module doesn't have a guaranty that a RDS Flavor is available in the calculated Availability Zones
  # It works well only for types calculated via 'huaweicloud_rds_flavors'
  # To avoid a chance to get the error {"error_msg":"Invalid AZ.","error_code":"DBS.280285"}
  # Set Availability Zones and RDS Flavor explicitly via variable
  ##
  az_data = local.flavor_explicit == null ? slice(data.huaweicloud_rds_flavors.flavor.flavors[0].availability_zones, 0, local.az_number) : slice(data.huaweicloud_availability_zones.zones.names, 0, local.az_number)
  az      = length(var.availability_zones) == 0 ? local.az_data : slice(var.availability_zones, 0, local.az_number)

  az_data_replica = var.flavors.replica == null ? element(data.huaweicloud_rds_flavors.flavor_replica.flavors[0].availability_zones, 0) : element(data.huaweicloud_availability_zones.zones.names, 0)
  az_replica      = length(var.availability_zone_replica) == 0 ? local.az_data_replica : element(var.availability_zone_replica, 0)
}

resource "huaweicloud_rds_instance" "main" {
  name                = local.name
  region              = var.region
  availability_zone   = local.az
  ha_replication_mode = var.instance_mode == "single" ? null : var.ha_replication_mode
  vpc_id              = var.vpc_id
  flavor              = local.flavor
  time_zone           = var.time_zone
  param_group_id      = length(var.parameter_group_values) == 0 ? null : huaweicloud_rds_parametergroup.main.0.id
  subnet_id           = var.subnet_id
  security_group_id   = var.security_group_id

  db {
    type     = "PostgreSQL"
    version  = var.postgres_version
    password = var.password
    port     = var.port
  }

  volume {
    type               = var.volume.type
    size               = var.volume.size
    disk_encryption_id = var.volume.disk_encryption_id
  }

  lifecycle {
    ignore_changes = [
      db[0].password
    ]
  }

  tags = var.tags
}


resource "huaweicloud_rds_database" "main" {
  for_each = var.databases

  instance_id   = huaweicloud_rds_instance.main.id
  name          = each.key
  character_set = each.value.character_set
  description   = each.value.description
}


resource "huaweicloud_rds_read_replica_instance" "replica" {
  count = var.replica ? 1 : 0

  name                = local.name_replica
  flavor              = local.flavor_replica
  primary_instance_id = huaweicloud_rds_instance.main.id
  availability_zone   = local.az_replica

  volume {
    type               = var.volume.type
    size               = var.volume.size
    disk_encryption_id = var.volume.disk_encryption_id
  }

  tags = var.tags
}


resource "huaweicloud_rds_parametergroup" "main" {
  count = length(var.parameter_group_values) == 0 ? 0 : 1

  name        = local.name
  description = format("RDS PostgreSQL Parameter Group for %s instance", local.name)
  region      = var.region
  values      = var.parameter_group_values

  datastore {
    type    = "PostgreSQL"
    version = var.postgres_version
  }
}
