variable "xx_db_count" {
  description = "Number of database created by xx"
  default=1
}
resource "oci_database_database" "xx_database" {
  count = var.xx_db_count
  #Required
  database {
    admin_password = "BEstr0ng###${count.index}"
    db_name        = "xxDb${count.index}"
    character_set  = "AL32UTF8"
    ncharacter_set = "AL16UTF16"
    db_workload    = "OLTP"
    pdb_name       = "xxPdb${count.index}"

    db_backup_config {
      auto_backup_enabled = false
    }
  }
  //It takes about 40 min to create 1 DB so make it simple to give an hour per DB
  timeouts {
      create = "${var.xx_db_count}h"
 }

  db_home_id = oci_database_db_home.prod_db_home.id
  source     = "NONE"
}
