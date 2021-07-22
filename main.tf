
#Create Group of users to the compartment for the activity
module "create_res" {
  source = "./resources"
  tenancy_ocid = var.tenancy_ocid
  region = var.region
  db_count = var.db_count
  uidList      = var.uidList
  activity_num = var.proj_id
  ecc_num = var.ecc_num
  clu_num = var.clu_num
}

#/* You need to comment out the next 2 output config if you are deleting IDs or you will get Invalid argument lenght when run terraform plan
output "accessCredentials" {
  sensitive = false
  value = formatlist(
    "echo '%v' | mailx -s 'OCI access info - DO NOT REPLY NOR FORWARD' -b albert.kwok@oracle.com %v",
    module.create_res.allUserInitialPasswords,
    var.uidList,
  )
}

output "allUserOCIDs" {
  sensitive = false
  value     = formatlist("%v %v", var.uidList, module.create_res.allUserOCIDs)
}
#*/
