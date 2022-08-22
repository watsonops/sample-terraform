## -- KMS Key
output "k8s_dev_kms01" {
  description = "AWS KMS 01"
  value       = try(aws_kms_key.k8s_dev_kms01.id, "")
}
## -- VPC
output "k8s_dev_vpc01" {
  description = "Main VPC 01"
  value       = try(aws_vpc.k8s_dev_vpc01.id, "")
}
## -- Public subs 
output "k8s_dev_subnet_pub01" {
  description = "Public Subnet 01"
  value = try(aws_subnet.k8s_dev_subnet_pub01.id, "")
}
output "k8s_dev_subnet_pub02" {
  description = "Public Subnet 02"
  value = try(aws_subnet.k8s_dev_subnet_pub02.id, "")
}
output "k8s_dev_subnet_pub03" {
  description = "Public Subnet 03"
  value = try(aws_subnet.k8s_dev_subnet_pub03.id, "")
}
## -- Private subs 
output "k8s_dev_subnet_prv01" {
  description = "Private Subnet 01"
  value = try(aws_subnet.k8s_dev_subnet_prv01.id, "")
}
output "k8s_dev_subnet_prv02" {
  description = "Private Subnet 02"
  value = try(aws_subnet.k8s_dev_subnet_prv02.id, "")
}
output "k8s_dev_subnet_prv03" {
  description = "Private Subnet 03"
  value = try(aws_subnet.k8s_dev_subnet_prv03.id, "")
}
## -- Internet Gateway 
output "k8s_dev_gw01" {
  description = "Internet Gateway 01"
  value = try(aws_internet_gateway.k8s_dev_gw01.id, "")
}
## -- Route tables
output "k8s_dev_pub_rt01" {
  description = "Public Route Table 01"
  value = try(aws_route_table.k8s_dev_pub_rt01.id, "")
}
## -- Security Groups
output "k8s_dev_sg_allow_ssh" {
  description = "Security group allow ssh"
  value = try(aws_security_group.k8s_dev_sg_allow_ssh.id, "")
}
output "k8s_dev_sg_allow_web" {
  description = "External web traffic"
  value = try(aws_security_group.k8s_dev_sg_allow_web.id, "")
}
output "k8s_dev_sg_allow_internal" {
  description = "Security group allow internal"
  value = try(aws_security_group.k8s_dev_sg_allow_internal.id, "")
}
## -- EC2 Instances 
output "my_vm_rhel" {
  description = "Red Hat 8"
  value = try(aws_instance.my_vm_rhel.id, "")
}

output "my_vm_ubuntu" {
  description = "Ubuntu 22.04"
  value = try(aws_instance.my_vm_ubuntu.id, "")
}

