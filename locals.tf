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

  argocd_elb_waf_name = "${var.cluster_name}-${var.argocd_elb_waf_name}"
  argocd_elb_waf_acl_visibility_config = merge(
    var.argocd_elb_waf_acl_visibility_config,
    {
      "metric_name" : "${replace("${var.cluster_name}-${var.argocd_elb_waf_name}-cloudwatch-metric", "_", "-")}"
    }
  )

}
