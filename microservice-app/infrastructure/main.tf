#Create ECR to hold images
resource "aws_ecr_repository" "myecr" {
  name = "${var.namespace}-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

#Create VPC, SG etc
#module "networking" {
#  source = "./modules/networking"
#  namespace = var.namespace
#}