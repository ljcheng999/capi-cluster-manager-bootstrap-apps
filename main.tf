provider "aws" {
  region = var.region

  # assume_role {
  #   role_arn = var.assume_role_str
  # }

}


module "capi_cluster_manager_bootstrap_app" {
  source = "../../modules/terraform-aws-capi-cluster-manager-bootstrap-apps"
  # source  = "ljcheng999/capi-cluster-manager-bootstrap-apps/aws"
  # version = "1.0.1"

  create                         = local.create
  cluster_name                   = local.cluster_name
  vpc_id                         = var.vpc_id
  route53_zone_id                = local.route53_zone_id
  public_subnet_ids              = local.public_subnet_ids
  custom_domain                  = local.custom_domain
  vpc_public_subnets_name_prefix = var.vpc_public_subnets_name_prefix

  ### AWS ELB
  create_aws_elb_controller                 = local.create_aws_elb_controller
  helm_release_aws_elb_controller_parameter = local.helm_release_aws_elb_controller_parameter

  ### External Secrets
  create_external_secrets                 = local.create_external_secrets
  helm_release_external_secrets_parameter = local.helm_release_external_secrets_parameter

  ### Velero
  create_velero_controller      = local.create_velero_controller
  helm_release_velero_parameter = local.helm_release_velero_parameter

  ### Metrics Server
  create_metrics_server_controller                 = local.create_metrics_server_controller
  helm_release_metrics_server_controller_parameter = local.helm_release_metrics_server_controller_parameter

  ### ArgoCD
  create_argocd_controller                 = local.create_argocd_controller
  helm_release_argocd_controller_parameter = local.helm_release_argocd_controller_parameter













  # tags = local.tags
  tags = merge(
    local.tags,
    local.addition_tags
  )
}


output "resources" {
  value = module.capi_cluster_manager_bootstrap_app
  # sensitive = true
}





