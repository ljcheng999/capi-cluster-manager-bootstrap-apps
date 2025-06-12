
addition_tags = {}

create                         = true
cluster_name                   = "capi-cm-poc"
custom_domain                  = "kubesources.com"
vpc_prefix                     = "upstream"
vpc_public_subnets_name_prefix = "upstream_vpc-public"


### AWS ELB
create_aws_elb_controller = false
helm_release_aws_elb_controller_parameter = {
  helm_repo_chart     = "aws-load-balancer-controller"
  helm_repo_version   = "1.13.2"
  helm_repo_namespace = "nginx"
}

### External Secrets
create_external_secrets = false
helm_release_external_secrets_parameter = {
  helm_repo_chart   = "external-secrets"
  helm_repo_version = "0.16.2"
}

### Metrics SErvice
create_metrics_server_controller = false
helm_release_metrics_server_controller_parameter = {
  helm_repo_chart   = "metrics-server"
  helm_repo_version = "3.12.2"
}

### Velero
create_velero_controller = true
helm_release_velero_parameter = {
  helm_repo_chart          = "velero"
  helm_repo_version        = "10.0.1"
  cloud_provider           = "aws"
  cloud_bucket             = "velero-ljcheng-cluster-backups"
  cloud_bucket_folder_name = "core-kubesources-cluster-backups"
  cloud_region             = "us-east-1"
  cloud_bucket_prefix      = "capi-cm-poc"
}


# ### ArgoCD
create_argocd = false
helm_release_argocd_parameter = {
  helm_repo_name    = "argocd"
  helm_repo_version = "8.0.13"
}
argocd_custom_domain = ""
helm_release_argocd_ingress_nginx_parameter = {
  helm_repo_name      = "ingress-nginx"
  helm_repo_version   = "4.12.2"
  helm_repo_namespace = "nginx"
}
argocd_alb_ingress_parameter = {
  argocd_alb_ingress_namespace                = "nginx"
  argocd_alb_ingress_healthcheck_path         = "/healthz"
  argocd_alb_ingress_load_balancer_attributes = "idle_timeout.timeout_seconds=600"
  argocd_alb_ingress_scheme                   = "internet-facing"
  argocd_alb_ingress_ssl_policy               = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  argocd_alb_ingress_success_codes            = "200"
  argocd_alb_ingress_target_type              = "instance"
  argocd_alb_ingress_certificate_arn          = ""
}

argocd_elb_waf_name                              = "argocd-elb-waf-acl"
argocd_elb_waf_default_action                    = "allow"
argocd_elb_waf_whitelist_ip_cidr                 = []
argocd_elb_waf_blocklist_ip_cidr                 = []
argocd_elb_waf_acl_resource_arn                  = []
argocd_elb_waf_acl_enabled_logging_configuration = true # cloudwatch
argocd_elb_waf_acl_visibility_config = {
  cloudwatch_metrics_enabled = true
  sampled_requests_enabled   = true
}
argocd_elb_waf_acl_log_destination_configs_arn = "" # Set this as an empty string so it will create cloudwatch group automatically

