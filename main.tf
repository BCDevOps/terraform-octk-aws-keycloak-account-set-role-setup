terraform {
	required_providers {
		keycloak = {
			source = "mrparkers/keycloak"
			version = "2.0.0"
		}
		aws = {
			source = "hashicorp/aws"
			version = "3.11.0"
		}
	}
}

provider "keycloak" {
	client_id = var.kc_terraform_auth_client_id
	client_secret = var.kc_terraform_auth_client_secret
	realm = var.kc_realm
	url = var.kc_base_url
}

locals {
	// massage new "role config" variable structure into original structure
	workload_account_roles = { for role_spec in var.workload_account_role_config : role_spec.aws_role_name => role_spec.aws_policy_arn }

	trusted_login_sources = var.custom_login_url == null ? [
		"https://signin.aws.amazon.com/saml"] : [
		"https://signin.aws.amazon.com/saml",
		var.custom_login_url]
	idp_name = "BCGovKeyCloak-${var.kc_realm}"
}

