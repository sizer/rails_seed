terraform {
  backend "s3" {
    bucket  = "rails-seed-terraform-backend"
    key     = "rails_seed/terraform.tfstate"
    profile = "rails_seed"
    region  = "ap-northeast-1"
  }
}
