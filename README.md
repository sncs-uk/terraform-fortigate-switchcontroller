<!-- BEGIN_TF_DOCS -->
# Fortigate Switch Controller configuration module

This terraform module configures some base switch controller configuration on a FortiGate firewall

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_fortios"></a> [fortios](#provider\_fortios) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [fortios_switchcontroller_snmpcommunity.community](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/switchcontroller_snmpcommunity) | resource |
| [fortios_switchcontroller_snmpuser.user](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/switchcontroller_snmpuser) | resource |
| [fortios_switchcontroller_switchprofile.profile](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/switchcontroller_switchprofile) | resource |
| [fortios_switchcontrollersecuritypolicy_8021X.dot1x](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/switchcontrollersecuritypolicy_8021X) | resource |
| [fortios_switchcontrollersecuritypolicy_localaccess.localaccess](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/switchcontrollersecuritypolicy_localaccess) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config_path"></a> [config\_path](#input\_config\_path) | Path to base configuration directory | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->