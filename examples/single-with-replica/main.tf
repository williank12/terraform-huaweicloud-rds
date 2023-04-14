provider "huaweicloud" {
  region = "ap-southeast-3"
}

module "vpc" {
  source  = "cloud-labs-infra/vpc/huaweicloud"
  version = "1.0.0"

  name = "dev01"
}

module "secgroup_postgres" {
  source  = "cloud-labs-infra/security-group/huaweicloud"
  version = "1.0.0"

  name         = "dev01"
  name_postfix = "postgres"

  rules = {
    "Egress Allow All" = {
      direction        = "egress"
      remote_ip_prefix = "0.0.0.0/0"
    },
    "Ingress Allow to the VPC" = {
      direction        = "ingress"
      remote_ip_prefix = module.vpc.vpc_cidr
    },
  }
}

module "postgres" {
  source  = "cloud-labs-infra/rds-postgres/huaweicloud"
  version = "1.0.0"

  name              = "dev01"
  security_group_id = module.secgroup_postgres.id
  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.private_subnets_ids[0]
  availability_zones = [
    "ap-southeast-3a",
  ]
  replica = true
  availability_zone_replica = [
    "ap-southeast-3e",
  ]
}
