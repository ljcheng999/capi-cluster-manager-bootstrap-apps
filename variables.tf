### Common

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

variable "vpc_prefix" {
  type    = string
  default = ""
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

variable "tags" {
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
  type = map(any)
  default = {
    helm_repo_name    = "external-secrets"
    helm_repo_version = "0.16.2"
  }
}

################################################################################
### Metrics Server
################################################################################

variable "create_metrics_server" {
  type    = bool
  default = false
}

variable "helm_release_metrics_server_parameter" {
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
### ArgoCD
################################################################################

variable "create_argocd" {
  type    = bool
  default = false
}

variable "helm_release_argocd_parameter" {
  type    = map(any)
  default = {}
}

variable "argocd_custom_domain" {
  type    = string
  default = ""
}
variable "argocd_admin_secret_params_name" {
  type    = string
  default = ""
}


variable "create_argocd_ingress_nginx_controller" {
  type    = bool
  default = false
}
variable "helm_release_argocd_ingress_nginx_parameter" {
  type    = map(any)
  default = {}
}

variable "argocd_alb_ingress_parameter" {
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

variable "argocd_elb_waf_name" {
  default = ""
}
variable "argocd_elb_waf_scope" {
  default = "REGIONAL"
}
variable "argocd_elb_waf_default_action" {
  default = "allow"
}

variable "argocd_elb_waf_whitelist_ip_cidr" {
  default = []
}
variable "argocd_elb_waf_blocklist_ip_cidr" {
  default = []
}

variable "argocd_elb_waf_acl_visibility_config" {
  default = {}
}
variable "argocd_elb_waf_acl_resource_arn" {
  type    = list(any)
  default = []
}
variable "argocd_elb_waf_acl_enabled_logging_configuration" {
  type    = bool
  default = false
}
variable "argocd_elb_waf_acl_log_destination_configs_arn" {
  type    = string
  default = ""
}

variable "argocd_upstream_project_role" {
  default = "cluster-manager"
}
variable "argocd_upstream_application_config" {
  default = {}
}


variable "argocd_elb_waf_rules" {
  default = [
    {
      name            = "AWSManagedRulesCommonRuleSet"
      priority        = 0
      override_action = "none"
      managed_rule_group_statement = {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
        # Deprecated - excluded_rule = ["NoUserAgent_HEADER", "UserAgent_BadBots_HEADER"]

        rule_action_override = [
          {
            name          = "CrossSiteScripting_BODY"
            action_to_use = "block"
          },
          {
            name          = "CrossSiteScripting_COOKIE"
            action_to_use = "block"
          },
          {
            name          = "CrossSiteScripting_QUERYARGUMENTS"
            action_to_use = "block"
          },
          {
            name          = "CrossSiteScripting_URIPATH"
            action_to_use = "block"
          },
          {
            name          = "EC2MetaDataSSRF_BODY"
            action_to_use = "block"
          },
          {
            name          = "EC2MetaDataSSRF_COOKIE"
            action_to_use = "block"
          },
          {
            name          = "EC2MetaDataSSRF_QUERYARGUMENTS"
            action_to_use = "block"
          },
          {
            name          = "EC2MetaDataSSRF_URIPATH"
            action_to_use = "block"
          },
          {
            name          = "GenericLFI_BODY"
            action_to_use = "block"
          },
          {
            name          = "GenericLFI_QUERYARGUMENTS"
            action_to_use = "block"
          },
          {
            name          = "GenericLFI_URIPATH"
            action_to_use = "block"
          },
          {
            name          = "GenericRFI_BODY"
            action_to_use = "block"
          },
          {
            name          = "GenericRFI_QUERYARGUMENTS"
            action_to_use = "block"
          },
          {
            name          = "GenericRFI_URIPATH"
            action_to_use = "block"
          },
          {
            name          = "NoUserAgent_HEADER"
            action_to_use = "block"
          },
          {
            name          = "RestrictedExtensions_QUERYARGUMENTS"
            action_to_use = "block"
          },
          {
            name          = "RestrictedExtensions_URIPATH"
            action_to_use = "block"
          },
          {
            name          = "SizeRestrictions_BODY"
            action_to_use = "block"
          },
          {
            name          = "SizeRestrictions_Cookie_HEADER"
            action_to_use = "block"
          },
          {
            name          = "SizeRestrictions_QUERYSTRING"
            action_to_use = "block"
          },
          {
            name          = "SizeRestrictions_URIPATH"
            action_to_use = "block"
          },
          {
            name          = "UserAgent_BadBots_HEADER"
            action_to_use = "block"
          },
        ]
      }
      visibility_config = {
        sampled_requests_enabled   = true
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesCommonRuleSet_cloudwatch_metric"
      }
    },
    {
      name            = "AWSManagedRulesKnownBadInputsRuleSet",
      priority        = 1
      override_action = "none"
      managed_rule_group_statement = {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
        # Deprecated - excluded_rule = ["NoUserAgent_HEADER", "UserAgent_BadBots_HEADER"]

        rule_action_override = [
          {
            name          = "JavaDeserializationRCE_BODY"
            action_to_use = "block"
          },
          {
            name          = "JavaDeserializationRCE_URIPATH"
            action_to_use = "block"
          },
          {
            name          = "JavaDeserializationRCE_QUERYSTRING"
            action_to_use = "block"
          },
          {
            name          = "JavaDeserializationRCE_HEADER"
            action_to_use = "block"
          },
          {
            name          = "Host_localhost_HEADER"
            action_to_use = "block"
          },
          {
            name          = "PROPFIND_METHOD"
            action_to_use = "block"
          },
          {
            name          = "ExploitablePaths_URIPATH"
            action_to_use = "block"
          },
          {
            name          = "Log4JRCE_QUERYSTRING"
            action_to_use = "block"
          },
          {
            name          = "Log4JRCE_BODY"
            action_to_use = "block"
          },
          {
            name          = "Log4JRCE_URIPATH"
            action_to_use = "block"
          },
          {
            name          = "Log4JRCE_HEADER"
            action_to_use = "block"
          },
        ]

        # scope_down_statement = {
        #   geo_match_statement = {
        #     country_codes : ["CN"]
        #   }
        # }
      }
      visibility_config = {
        sampled_requests_enabled   = true
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesKnownBadInputsRuleSet_cloudwatch_metric"
      }
    },
    {
      name            = "AWSManagedRulesAmazonIpReputationList"
      priority        = 2
      override_action = "none"
      managed_rule_group_statement = {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
        rule_action_override = [
          {
            name          = "AWSManagedIPDDoSList"
            action_to_use = "block"
          },
          {
            name          = "AWSManagedIPReputationList"
            action_to_use = "block"
          },
          {
            name          = "AWSManagedReconnaissanceList"
            action_to_use = "block"
          },
        ]
      }
      visibility_config = {
        sampled_requests_enabled   = true
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesAmazonIpReputationList_cloudwatch_metric"
      }
    },
    {
      name            = "AWSManagedRulesLinuxRuleSet",
      priority        = 3
      override_action = "none"
      managed_rule_group_statement = {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
        # Deprecated - excluded_rule = ["NoUserAgent_HEADER", "UserAgent_BadBots_HEADER"]

        rule_action_override = [
          {
            name          = "LFI_HEADER"
            action_to_use = "block"
          },
          {
            name          = "LFI_QUERYSTRING"
            action_to_use = "block"
          },
          {
            name          = "LFI_URIPATH"
            action_to_use = "block"
          },
        ]
      }
      visibility_config = {
        sampled_requests_enabled   = true
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesLinuxRuleSet_cloudwatch_metric"
      }
    },
    {
      name            = "AWSManagedRulesAdminProtectionRuleSet",
      priority        = 4
      override_action = "none"
      managed_rule_group_statement = {
        name        = "AWSManagedRulesAdminProtectionRuleSet"
        vendor_name = "AWS"
        # Deprecated - excluded_rule = ["NoUserAgent_HEADER", "UserAgent_BadBots_HEADER"]

        rule_action_override = [
          {
            name          = "AdminProtection_URIPATH"
            action_to_use = "block"
          },
        ]
      }
      visibility_config = {
        sampled_requests_enabled   = true
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesAdminProtectionRuleSet_cloudwatch_metric"
      }
    },
    {
      name            = "AWSManagedRulesBotControlRuleSet",
      priority        = 5
      override_action = "none"
      managed_rule_group_statement = {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
        # Deprecated - excluded_rule = ["NoUserAgent_HEADER", "UserAgent_BadBots_HEADER"]
        managed_rule_group_configs = [
          {
            aws_managed_rules_bot_control_rule_set = {
              inspection_level = "COMMON"
            }
          }
        ]
        rule_action_override = [
          {
            name          = "CategoryAI"
            action_to_use = "block"
          },
          {
            name          = "CategoryAdvertising"
            action_to_use = "block"
          },
          {
            name          = "CategoryArchiver"
            action_to_use = "block"
          },
          {
            name          = "CategoryContentFetcher"
            action_to_use = "block"
          },
          {
            name          = "CategoryEmailClient"
            action_to_use = "block"
          },
          {
            name          = "CategoryHttpLibrary"
            action_to_use = "block"
          },
          {
            name          = "CategoryLinkChecker"
            action_to_use = "block"
          },
          {
            name          = "CategoryMiscellaneous"
            action_to_use = "block"
          },
          {
            name          = "CategoryMonitoring"
            action_to_use = "block"
          },
          {
            name          = "CategoryScrapingFramework"
            action_to_use = "block"
          },
          {
            name          = "CategorySearchEngine"
            action_to_use = "block"
          },
          {
            name          = "CategorySecurity"
            action_to_use = "block"
          },
          {
            name          = "CategorySeo"
            action_to_use = "block"
          },
          {
            name          = "CategorySocialMedia"
            action_to_use = "block"
          },
          {
            name          = "SignalAutomatedBrowser"
            action_to_use = "block"
          },
          {
            name          = "SignalKnownBotDataCenter"
            action_to_use = "block"
          },
          {
            name          = "SignalNonBrowserUserAgent"
            action_to_use = "block"
          },
        ]
      }
      visibility_config = {
        sampled_requests_enabled   = true
        cloudwatch_metrics_enabled = true
        metric_name                = "AWS-AWSManagedRulesBotControlRuleSet_cloudwatch_metric"
      }
    },
    # {
    #   name     = "GeoFencing"
    #   priority = 9
    #   action   = "block"

    #   custom_response = {
    #     response_code = 403
    #     response_header = [
    #       {
    #         name  = "geo_fencing"
    #         value = "geo_fencing_block"
    #       }
    #     ]
    #   }

    #   custom_response_body = {
    #     key          = "Geo_fencing",
    #     content      = "Geo_fencing_error",
    #     content_type = "TEXT_PLAIN"
    #   }

    #   not_statement = {
    #     geo_match_statement = {
    #       country_codes : [
    #         "US",
    #         "UM",
    #         "CA",
    #         "IN",
    #         "MX",
    #         "PK",
    #         "GB"
    #       ]
    #     }
    #   }

    #   visibility_config = {
    #     sampled_requests_enabled   = true
    #     cloudwatch_metrics_enabled = false
    #     metric_name                = "GeoFencing_cloudwatch_metric"
    #   }
    # },
    {
      name     = "RateBasedLimiting"
      priority = 6
      action   = "block"

      custom_response = {
        response_code = 429
        response_header = [
          {
            name  = "rate_limiting_header"
            value = "too_many_requests_error"
          }
        ]
      }

      custom_response_body = {
        key          = "Too_many_requests",
        content      = "Too many requests",
        content_type = "TEXT_PLAIN"
      }

      rate_based_statement = {
        limit                 = 10000
        aggregate_key_type    = "IP"
        evaluation_window_sec = 120
      }
      visibility_config = {
        sampled_requests_enabled   = true
        cloudwatch_metrics_enabled = false
        metric_name                = "rateLimitingCloudwatch_metric_name"
      }
    }
  ]
}






