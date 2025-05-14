
addition_tags = {}

create          = true
cluster_name    = "capi-cm-poc"
route53_zone_id = "Z02548442OA65RYWCE62R"
custom_domain   = "kubesources.com"
vpc_id          = "vpc-060240292d675c06e"

### External Secrets
create_external_secrets = true
helm_release_external_secrets_parameter = {
  helm_repo_name    = "external-secrets"
  helm_repo_version = "0.16.2"
}

### AWS ELB
create_aws_elb_controller = true
helm_release_aws_elb_controller_parameter = {
  helm_repo_name      = "aws-load-balancer-controller"
  helm_repo_version   = "1.13.0"
  helm_repo_namespace = "nginx"
}

### AWS Velero
create_metrics_server_controller = true
helm_release_metrics_server_controller_parameter = {
  helm_repo_name    = "metrics-server"
  helm_repo_version = "3.12.2"
}

### Velero
create_velero_controller = false
helm_release_velero_parameter = {
  helm_repo_chart          = "velero"
  helm_repo_namespace      = "velero"
  helm_repo_url            = "https://vmware-tanzu.github.io/helm-charts"
  helm_repo_name           = "velero"
  helm_repo_crd            = null
  helm_repo_version        = "9.1.0"
  cloud_provider           = "aws"
  cloud_bucket             = "velero-ljcheng-cluster-backups"
  cloud_bucket_folder_name = "core-kubesources-cluster-backups"
  cloud_region             = "us-east-1"
  cloud_bucket_prefix      = "capi-cm-poc"
}


### ArgoCD
create_argocd_controller = true
helm_release_argocd_controller_parameter = {
  helm_repo_name                                  = "argocd"
  helm_repo_version                               = "8.0.0"
  helm_repo_create_argocd_cert                    = true
  helm_repo_create_wildcard_argocd_cert           = true
  helm_repo_ingressclassname                      = "alb"
  helm_repo_custom_argocd_subdomain               = "ljcheng"
  aws_argocd_alb_ingress_create                   = true
  aws_argocd_alb_ingress_certificate_arn          = ""
  aws_argocd_alb_ingress_load_balancer_attributes = "idle_timeout.timeout_seconds=600"
  aws_argocd_alb_ingress_scheme                   = "internet-facing"
  aws_argocd_alb_ingress_target_type              = "instance"
  aws_argocd_alb_ingress_namespace                = "nginx"
  aws_argocd_alb_ingress_classname                = "alb"
}







