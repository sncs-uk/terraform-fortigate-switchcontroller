/**
 * # Fortigate Switch Controller configuration module
 *
 * This terraform module configures some base switch controller configuration on a FortiGate firewall
 */
terraform {
  required_version = ">= 1.11.0"
  required_providers {
    fortios = {
      source  = "fortinetdev/fortios"
      version = ">= 1.22.0"
    }
  }
}
locals {
  switches_yaml = fileexists("${var.config_path}/managed-switches.yaml") ? yamldecode(file("${var.config_path}/managed-switches.yaml")) : object({})
}

resource "fortios_switchcontroller_snmpuser" "user" {
  for_each = { for user in try(local.switches_yaml.snmp.users, []) : user.name => user }

  name = each.key

  queries        = try(each.value.queries, null)
  query_port     = try(each.value.query_port, null)
  security_level = try(each.value.security_level, null)
  auth_proto     = try(each.value.auth_proto, null)
  auth_pwd       = try(each.value.auth_pwd, null)
  priv_proto     = try(each.value.priv_proto, null)
  priv_pwd       = try(each.value.priv_pwd, null)
}

resource "fortios_switchcontroller_snmpcommunity" "community" {
  for_each = { for community in try(local.switches_yaml.snmp.communities, []) : community.name => community }

  name             = try(each.value.name, null)
  status           = try(each.value.status, "enable")
  query_v1_status  = (try(each.value.version, "v2c") == "v1") ? "enable" : "disable"
  query_v1_port    = (try(each.value.version, "v2c") == "v1") ? try(each.value.port, null) : null
  query_v2c_status = (try(each.value.version, "v2c") == "v2c") ? "enable" : "disable"
  query_v2c_port   = (try(each.value.version, "v2c") == "v2c") ? try(each.value.port, null) : null
  dynamic "hosts" {
    for_each = try(each.value.hosts, {})
    content {
      id = index(each.value.hosts, hosts.value) + 1
      ip = hosts.value
    }
  }
}

resource "fortios_switchcontroller_switchprofile" "profile" {
  for_each = { for name, profile in try(local.switches_yaml.profiles, []) : name => profile }

  name                       = each.key
  login_passwd_override      = try(each.value.login_passwd_override, null)
  login_passwd               = try(each.value.login_passwd, null)
  login                      = try(each.value.login, null)
  revision_backup_on_logout  = try(each.value.revision_backup_on_logout, null)
  revision_backup_on_upgrade = try(each.value.revision_backup_on_upgrade, null)
}

resource "fortios_switchcontrollersecuritypolicy_localaccess" "localaccess" {
  for_each = { for name, profile in try(local.switches_yaml.localaccess, []) : name => profile }

  name                 = each.key
  mgmt_allowaccess     = join(" ", try(each.value.mgmt_allowaccess, []))
  internal_allowaccess = join(" ", try(each.value.internal_allowaccess, []))
}

resource "fortios_switchcontrollersecuritypolicy_8021X" "dot1x" {
  for_each = { for name, profile in try(local.switches_yaml.port-security-policies, []) : name => profile }

  name                             = each.key
  security_mode                    = try(each.value.security_mode, null)
  mac_auth_bypass                  = try(each.value.mac_auth_bypass, null)
  auth_order                       = try(each.value.auth_order, null)
  auth_priority                    = try(each.value.auth_priority, null)
  open_auth                        = try(each.value.open_auth, null)
  eap_passthru                     = try(each.value.eap_passthru, null)
  eap_auto_untagged_vlans          = try(each.value.eap_auto_untagged_vlans, null)
  guest_vlan                       = try(each.value.guest_vlan, null)
  guest_vlanid                     = try(each.value.guest_vlanid, null)
  guest_vlan_id                    = try(each.value.guest_vlan_id, null)
  guest_auth_delay                 = try(each.value.guest_auth_delay, null)
  auth_fail_vlan                   = try(each.value.auth_fail_vlan, null)
  auth_fail_vlanid                 = try(each.value.auth_fail_vlanid, null)
  auth_fail_vlan_id                = try(each.value.auth_fail_vlan_id, null)
  framevid_apply                   = try(each.value.framevid_apply, null)
  radius_timeout_overwrite         = try(each.value.radius_timeout_overwrite, null)
  policy_type                      = try(each.value.policy_type, null)
  authserver_timeout_period        = try(each.value.authserver_timeout_period, null)
  authserver_timeout_vlan          = try(each.value.authserver_timeout_vlan, null)
  authserver_timeout_vlanid        = try(each.value.authserver_timeout_vlanid, null)
  authserver_timeout_tagged        = try(each.value.authserver_timeout_tagged, null)
  authserver_timeout_tagged_vlanid = try(each.value.authserver_timeout_tagged_vlanid, null)
  dacl                             = try(each.value.dacl, null)
  vdomparam                        = try(each.value.vdomparam, null)

  dynamic "user_group" {
    for_each = { for group in try(each.value.user_groups, []) : group => group }
    content {
      name = group.value
    }
  }
}
