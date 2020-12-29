#import the networking module and set its inputs
module "networking" {
  source = "./modules/networking"
  namespace = var.namespace
}

module "database" {
  source = "./modules/database"
  namespace = var.namespace

  #implicit dependency on networking
  vpc = module.networking.vpc
  sg = module.networking.sg
}

module "autoscaling" {
  source = "./modules/autoscaling"
  namespace = var.namespace
  ssh_keypair = var.ssh_keypair
  vpc = module.networking.vpc
  sg = module.networking.sg
  db_config = module.database.db_config
}