variable "region" {
  description = "AWS default region"
  type        = string
  default     = "us-east-1"
}

variable "assume_role_str" {
  description = "AWS assume-role arn - useful for runner contexts and shared system(s)"
  type        = string
  nullable    = true
  default     = ""
}
variable "vpc_id" {
  description = "AWS VPC id"
  type        = string
  nullable    = true
  default     = "vpc-060240292d675c06e"
}
variable "vpc_public_subnets_name_prefix" {
  type    = string
  default = "upstream_vpc-public"
}

variable "custom_domain" {
  type    = string
  default = "kubesources.com"
}

variable "route53_zone_id" {
  type    = string
  default = "Z02763451I8QENECRLHM9"
}

variable "addition_tags" {
  type    = map(any)
  default = {}
}
# variable "tags" {
#   description = "Company required tags - used for billing metadata and cloud-related monitoring, automation"

#   type = object({
#     organization    = string
#     group           = string
#     team            = string
#     stack           = string
#     email           = string
#     application     = string
#     automation_tool = string

#     # organization    = "engineering"
#     # group           = "platform"
#     # team            = "enablement"
#     # stack           = "capi"
#     # email           = "test123@gmail.com"
#     # application     = "capi-cluster-manager-bootstrap-apps"
#     # automation_tool = "terraform"
#   })

#   validation {
#     condition     = (var.tags.organization != null) || (var.tags.group != null) || (var.tags.team != null) || (var.tags.stack != null) || (var.tags.email != null) || (var.tags.application != null) || (var.tags.automation_tool != null) || (var.tags.automation_path != null)
#     error_message = "All `var.tags` must be defined: \"group\", \"team\", \"stack\", \"email\", \"application\", \"automation_tool\", \"automation_path\""
#   }
# }

variable "public_subnet_ids" {
  type    = list(any)
  default = []
}

variable "create" {
  description = "Controls if resources should be created (affects nearly all resources)"
  type        = bool
  default     = true
}

variable "default_helm_release_set_parameter" {
  # type = list(object({
  #   name  = string
  #   value = string
  # }))
  default = [
    {
      name  = "tolerations[0].key"
      value = "node-role.kubernetes.io/control-plan"
    },
    {
      name  = "tolerations[0].value"
      value = "true"
    },
    {
      name  = "tolerations[0].operator"
      value = "Equal"
    },
    {
      name  = "tolerations[0].effect"
      value = "NoSchedule"
    },
  ]
}

################################################################################
# Cluster
################################################################################

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "cluster-manager"
}


variable "create_argocd" {
  type    = bool
  default = false
}

################################################################################
# Helm Charts Parameters
################################################################################

##########################################################
### AWS ELB Controller
################################################################################

variable "create_aws_elb_controller" {
  type    = bool
  default = false
}

variable "helm_release_aws_elb_controller_parameter" {
  type    = map(any)
  default = {}
}

################################################################################
### External Secrets
################################################################################

variable "create_external_secrets" {
  type    = bool
  default = false
}

variable "helm_release_external_secrets_parameter" {
  type    = map(any)
  default = {}
}

################################################################################
### Velero
################################################################################

variable "create_velero_controller" {
  type    = bool
  default = false
}

variable "helm_release_velero_parameter" {
  type    = map(any)
  default = {}
}

################################################################################
### Metrics Server
################################################################################

variable "create_metrics_server_controller" {
  type    = bool
  default = false
}
variable "create_metrics_server_controller_namespace" {
  type    = bool
  default = true
}
variable "helm_release_metrics_server_controller_parameter" {
  type = map(any)
  default = {
    helm_repo_namespace = ""
    helm_repo_url       = ""
    helm_repo_name      = ""
    helm_repo_crd       = ""
    helm_repo_timeout   = 4000
    helm_repo_version   = ""
  }
}






################################################################################
### ArgoCD
################################################################################

variable "create_argocd_controller" {
  type    = bool
  default = false
}

variable "helm_release_argocd_controller_parameter" {
  type    = map(any)
  default = {}
}


# variable "argocd_keycloak_client_issuer" {
#   description = "keycloak issuer of argocd"
#   type        = string
#   default     = ""
# }
# variable "argocd_keycloak_client_id" {
#   description = "keycloak id of argocd"
#   type        = string
#   default     = ""
# }




######################
