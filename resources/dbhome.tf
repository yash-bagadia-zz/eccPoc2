resource "oci_database_db_home" "prod_db_home" {
  vm_cluster_id = local.vmids[var.ecc_num][var.clu_num]
  source       = "VM_CLUSTER_NEW"
  database {
    admin_password = "BEstr0ng###0"
    db_name        = "a${var.clu_num}Db0"
    pdb_name       = "a${var.clu_num}Pdb0"
    character_set  = "AL32UTF8"
    ncharacter_set = "AL16UTF16"
    db_workload    = "OLTP"

    db_backup_config {
      auto_backup_enabled = false
    }
  }
  db_version   = "19.0.0.0"
  lifecycle {
    ignore_changes = [database]
  }
  display_name = "Prod-OH"
}

resource "oci_database_db_home" "patched_db_home" {
  vm_cluster_id = local.vmids[var.ecc_num][var.clu_num]
  source       = "VM_CLUSTER_NEW"
  database {
    admin_password = "BEstr0ng###0"
    db_name        = "n${var.clu_num}Db0"
    pdb_name       = "n${var.clu_num}Pdb0"
    character_set  = "AL32UTF8"
    ncharacter_set = "AL16UTF16"
    db_workload    = "OLTP"

    db_backup_config {
      auto_backup_enabled = false
    }
  }
  db_version   = "19.0.0.0"
  lifecycle {
    ignore_changes = [database]
  }
  display_name = "Patched-OH"
  provisioner "local-exec" {
    command = "./bin/patchDB.sh ${self.id} ${var.region}"
  }
  // Make sure to create prod OH as the above patch will update the default SW PSU
  depends_on = [
    oci_database_db_home.prod_db_home,
  ]
}

resource "oci_database_db_home" "dg_db_home" {
  vm_cluster_id = local.vmids[var.ecc_num][var.clu_num]
  source       = "VM_CLUSTER_NEW"
  database {
    admin_password = "BEstr0ng###0"
    db_name        = "g${var.clu_num}Db0"
    pdb_name       = "g${var.clu_num}Pdb0"
    character_set  = "AL32UTF8"
    ncharacter_set = "AL16UTF16"
    db_workload    = "OLTP"

    db_backup_config {
      auto_backup_enabled = false
    }
  }
  db_version   = "19.0.0.0"
  lifecycle {
    ignore_changes = [database]
  }
  display_name = "DG-OH"
  provisioner "local-exec" {
    command = "./bin/patchDB.sh ${self.id} ${var.region}"
  }
  // Make sure to create prod OH as the above patch will update the default SW PSU
  depends_on = [
    oci_database_db_home.patched_db_home,
  ]
}