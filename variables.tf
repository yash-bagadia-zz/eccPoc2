# ---- use variables defined in terraform.tfvars file
variable "tenancy_ocid" { }
variable "region" { default="us-ashburn-1" }
variable "proj_id" { default="fiserv164299" }
variable "ecc_num" { default=5 }
variable "clu_num" { default=4 }
variable "uidList" {
  type = list(string)
  default = [
    "david.lapoint@oracle.com",
    "sergiy.sokolovskiy@oracle.com",
    "kannan.s.viswanathan@oracle.com",
    "daniel.nuno@oracle.com",
    "edi.morales@oracle.com",
    "siddharth.shankaran@oracle.com",
    "luis.f.reyes@oracle.com",
  ]
}
variable "db_count" { default=0 }