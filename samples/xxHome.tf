variable "vm_clu_id" {
/*
"ecc3c2 ocid1.vmcluster.oc1.phx.abyhqljsn7j4ptukb43ygzr444puljwjqbtwc4j24sm6f43xtswdjiiljauq"
"ecc5c7 ocid1.vmcluster.oc1.iad.abuwcljtbz4fa74b3dtlyaqh2uauxtjrqlf7sdlozxb3v73cvylf4exc246a"
*/
  default = "ocid1.vmcluster.oc1.iad.abuwcljtbz4fa74b3dtlyaqh2uauxtjrqlf7sdlozxb3v73cvylf4exc246a"
}
// The creation of an oci_database_db_system requires that it be created with exactly one oci_database_db_home. Therefore the first db home will have to be a property of the db system resource and any further db homes to be added to the db system will have to be added as first class resources using "oci_database_db_home".
resource "oci_database_db_home" "xx_db_home" {
  vm_cluster_id = var.vmid
  source       = "VM_CLUSTER_NEW"
  database {
    admin_password = "BEstr0ng###0"
    db_name        = "xxDb0"
    pdb_name       = "xxPdb0"
    character_set  = "AL32UTF8"
    ncharacter_set = "AL16UTF16"
    db_workload    = "OLTP"

    db_backup_config {
      auto_backup_enabled = false
    }
  }
  db_version   = "19.0.0.0"
//db_version   = "12.2.0.1"
//db_version   = "12.1.0.2"
  display_name = "xx-OH"
}
