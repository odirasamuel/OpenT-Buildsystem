provider "aws" {
  profile = var.profile

  region = var.region

  default_tags {
    tags = {
      ou          = "robotics"
      instance    = var.instance
      environment = var.env
    }
  }
}