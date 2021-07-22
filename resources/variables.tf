variable "tenancy_ocid" {}
variable "region" {}
variable "activity_num" {}
variable "ecc_num" {}
variable "clu_num" {}
variable "db_count" { default=0 }
variable "uidList" {
  type = list(string)
}