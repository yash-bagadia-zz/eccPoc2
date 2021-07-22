resource "oci_identity_group" "viewOnlyGroup" {
  name           = "OSC${var.activity_num}ViewOnly"
  description    = "group created by terraform"
  compartment_id = var.tenancy_ocid
}
resource "oci_identity_policy" "policyViewOnly" {
  name           = "OSC${var.activity_num}PolicyViewOnly"
  description    = "policy created by terraform"
  compartment_id = var.tenancy_ocid

  statements = [
    "Allow group id ${oci_identity_group.viewOnlyGroup.id} to read all-resources in compartment id ${local.comp_vm[var.ecc_num][var.clu_num]}",
    "Allow group id ${oci_identity_group.viewOnlyGroup.id} to manage objects in compartment id ${local.comp_vm[var.ecc_num][var.clu_num]} where all {request.permission = 'OBJECT_CREATE'}",
    # The following 3 statement is to allow viewonly lab 1 and 2 for lesson 5: security and access control
    "Allow group id ${oci_identity_group.viewOnlyGroup.id} to read users in tenancy",
    "Allow group id ${oci_identity_group.viewOnlyGroup.id} to read groups in tenancy",
    "Allow group id ${oci_identity_group.viewOnlyGroup.id} to read policies in tenancy",
    #The next policy is to allow user to do the AUDIT lab as creating/upload object does not have a "Request action types" to be filtered on therefore, we need to allow them to create bucket that has an action type of POST
    "Allow group id ${oci_identity_group.viewOnlyGroup.id} to manage buckets in compartment id ${local.comp_vm[var.ecc_num][var.clu_num]} where all {request.permission = 'BUCKET_CREATE'}"
  ]
}
output "viewOnlyGroupId" {
  depends_on = [
    oci_identity_policy.policyViewOnly,
    oci_identity_group.sysAdminGroup,
    oci_identity_policy.policysysAdmin,
    ]
  value     = oci_identity_group.viewOnlyGroup.id
}
resource "oci_identity_group" "dbaGroup" {
  name           = "OSC${var.activity_num}dba"
  description    = "group created by terraform"
  compartment_id = var.tenancy_ocid
}

resource "oci_identity_policy" "policydba" {
  name           = "OSC${var.activity_num}Policydba"
  description    = "policy created by terraform"
  compartment_id = var.tenancy_ocid

  statements = [
    "Allow group id ${oci_identity_group.dbaGroup.id} to manage db-homes in compartment id ${local.comp_vm[var.ecc_num][var.clu_num]}",
    "Allow group id ${oci_identity_group.dbaGroup.id} to manage databases in compartment id ${local.comp_vm[var.ecc_num][var.clu_num]}",
    #Allow DBA to use stack with terraform and VCS such as GitHub, GitLab, etc.
    "Allow group id ${oci_identity_group.dbaGroup.id} to use orm-stacks in tenancy",
    "Allow group id ${oci_identity_group.dbaGroup.id} to manage orm-jobs in tenancy",
  ]
}

output "dbaGroupId" {
  depends_on = [
    oci_identity_policy.policydba,
    oci_identity_group.sysAdminGroup,
    oci_identity_policy.policysysAdmin,
  ]
  value = oci_identity_group.dbaGroup.id
}
resource "oci_identity_group" "sysAdminGroup" {
  name           = "OSC${var.activity_num}sysAdmin"
  description    = "Group for System administrator to scale VM Cluster"
  compartment_id = var.tenancy_ocid
}
resource "oci_identity_policy" "policysysAdmin" {
  name           = "OSC${var.activity_num}PolicysysAdmin"
  description    = "Policy for System administrator to scale VM Cluster"
  compartment_id = var.tenancy_ocid

  statements = [
    #Allow sysAdmin group to scale VM Cluster, wait 10min to effect non home region
    "Allow group id ${oci_identity_group.sysAdminGroup.id} to use exadata-infrastructures in compartment id ${local.comp_infra[var.ecc_num]}",
    "Allow group id ${oci_identity_group.sysAdminGroup.id} to use vmclusters in compartment id ${local.comp_vm[var.ecc_num][var.clu_num]}",
    "Allow group id ${oci_identity_group.sysAdminGroup.id} to manage db-nodes in compartment id ${local.comp_vm[var.ecc_num][var.clu_num]}",
    #Allow sysAdmin to create and delete stack with terraform and VCS such as GitHub, GitLab, etc.
    "Allow group id ${oci_identity_group.dbaGroup.id} to manage orm-stacks in tenancy",
    "Allow group id ${oci_identity_group.dbaGroup.id} to manage orm-jobs in tenancy",
  ]
}
output "sysAdminGroupId" {
  value     = oci_identity_group.sysAdminGroup.id
}
