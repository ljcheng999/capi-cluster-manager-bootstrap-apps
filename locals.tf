locals {
  tags = {
    organization    = "engineering"
    group           = "platform"
    team            = "enablement"
    stack           = "capi"
    email           = "example.${var.custom_domain}"
    application     = "capi-cluster-manager-bootstrap-apps"
    automation_tool = "terraform"
  }
  addition_tags = var.addition_tags


  create          = var.create
  cluster_name    = var.cluster_name
  route53_zone_id = var.route53_zone_id
  custom_domain   = var.custom_domain
  # public_subnet_ids = var.public_subnet_ids

  ### AWS ELB
  create_aws_elb_controller                 = var.create_aws_elb_controller
  helm_release_aws_elb_controller_parameter = var.helm_release_aws_elb_controller_parameter

  ### External Secrets
  create_external_secrets                 = var.create_external_secrets
  helm_release_external_secrets_parameter = var.helm_release_external_secrets_parameter

  ### Velero
  create_velero_controller      = var.create_velero_controller
  helm_release_velero_parameter = var.helm_release_velero_parameter

  ### Metrics Server
  create_metrics_server_controller                 = var.create_metrics_server_controller
  helm_release_metrics_server_controller_parameter = var.helm_release_metrics_server_controller_parameter


  ### ArgoCD
  create_argocd_controller                    = var.create_argocd_controller
  helm_release_argocd_controller_parameter    = var.helm_release_argocd_controller_parameter
  create_argocd_ingress_nginx_controller      = var.create_argocd_ingress_nginx_controller
  helm_release_argocd_ingress_nginx_parameter = var.helm_release_argocd_ingress_nginx_parameter
  # argocd_endpoint                          = "${var.cluster_name}.${var.custom_argocd_subdomain}.${var.custom_domain}"








}
