module "networking" {
  source = "./modules/networking"
}

module "eks" {
  source             = "./modules/eks"
  private_subnet_ids = module.networking.private_subnet_ids
  cluster_name       = var.cluster_name
}
module "observability" {
  source       = "./modules/observability"
  region       = var.region
  cluster_name = var.cluster_name
}