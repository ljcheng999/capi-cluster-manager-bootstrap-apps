provider "aws" {
  region = var.region

  # assume_role {
  #   role_arn = var.assume_role_str
  # }
}


module "capi_cluster_manager_bootstrap_app" {
  source = "../../modules/terraform-aws-capi-cluster-manager-bootstrap-apps"
  # source  = "ljcheng999/capi-cluster-manager-bootstrap-apps/aws"
  # version = "1.0.11"

  create       = var.create
  cluster_name = var.cluster_name
  vpc_prefix   = var.vpc_prefix

  custom_domain                  = var.custom_domain
  vpc_public_subnets_name_prefix = var.vpc_public_subnets_name_prefix

  ### AWS ELB
  create_aws_elb_controller                 = var.create_aws_elb_controller
  helm_release_aws_elb_controller_parameter = var.helm_release_aws_elb_controller_parameter

  ### External Secrets
  create_external_secrets                 = var.create_external_secrets
  helm_release_external_secrets_parameter = var.helm_release_external_secrets_parameter

  ### Metrics Server
  create_metrics_server                 = var.create_metrics_server
  helm_release_metrics_server_parameter = var.helm_release_metrics_server_parameter

  ### Velero
  create_velero_controller      = var.create_velero_controller
  helm_release_velero_parameter = var.helm_release_velero_parameter

  ### ArgoCD
  create_argocd                               = var.create_argocd
  helm_release_argocd_parameter               = var.helm_release_argocd_parameter
  argocd_hostname                             = var.argocd_custom_domain != "" ? "${var.cluster_name}.${var.argocd_custom_domain}.${var.custom_domain}" : "${var.cluster_name}.${var.custom_domain}"
  argocd_admin_secret_params_name             = "/cluster-manager/${var.cluster_name}/secrets/argocd/admin_password"
  helm_release_argocd_ingress_nginx_parameter = var.helm_release_argocd_ingress_nginx_parameter
  argocd_alb_ingress_parameter                = var.argocd_alb_ingress_parameter

  ### WAF/Cloudwatch for ArgoCD
  argocd_elb_waf_name                              = local.argocd_elb_waf_name
  argocd_elb_waf_scope                             = var.argocd_elb_waf_scope
  argocd_elb_waf_default_action                    = var.argocd_elb_waf_default_action
  argocd_elb_waf_rules                             = var.argocd_elb_waf_rules
  argocd_elb_waf_acl_visibility_config             = local.argocd_elb_waf_acl_visibility_config
  argocd_elb_waf_acl_resource_arn                  = var.argocd_elb_waf_acl_resource_arn
  argocd_elb_waf_acl_enabled_logging_configuration = var.argocd_elb_waf_acl_enabled_logging_configuration
  argocd_elb_waf_acl_log_destination_configs_arn   = var.argocd_elb_waf_acl_log_destination_configs_arn

  argocd_upstream_projects_roles     = var.argocd_upstream_projects_roles
  argocd_upstream_application_config = var.argocd_upstream_application_config

  argocd_repo_creds = var.argocd_repo_creds

  tags = merge(
    local.tags,
    var.addition_tags
  )
}






