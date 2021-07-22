
resource "oci_identity_user" "users" {
  count               = length(var.uidList)
  name           = var.uidList[count.index]
  email          = var.uidList[count.index]
  description    = "user for PoC activity ${var.activity_num}"
  compartment_id = var.tenancy_ocid
}
resource "oci_identity_ui_password" "passwords" {
  count               = length(var.uidList)
  user_id        = oci_identity_user.users.*.id[count.index]
}
resource "oci_identity_user_group_membership" "view-mem1" {
  count               = length(var.uidList)
  user_id        = oci_identity_user.users[count.index].id
  group_id       = oci_identity_group.viewOnlyGroup.id
}
resource "oci_identity_user_group_membership" "dba-mem1" {
  count               = length(var.uidList)
  user_id        = oci_identity_user.users[count.index].id
  group_id       = oci_identity_group.dbaGroup.id
}
resource "oci_identity_user_group_membership" "sysAdmin-mem1" {
  count               = length(var.uidList)
  user_id        = oci_identity_user.users[count.index].id
  group_id       = oci_identity_group.sysAdminGroup.id
}

output "allUserInitialPasswords" {
  sensitive = false
  value     = oci_identity_ui_password.passwords.*.password
}
output "allUserOCIDs" {
  sensitive = false
  value     = oci_identity_user.users.*.id
}