
variable "aws_region"{
    description = "AWS Region"
    type = string
    default = "us-east-1"
}

variable "aws_region_zone01"{
    description = "AWS Zone"
    type = string
    default = "us-east-1a"
}

variable "bucket_name" {
    description = "AWS bucket name"
    type = string
    default = "tf-state-s3-bucket-20220513"  
}

variable "dyndb_name"{
    description = "Dynamodb lock table name"
    type = string
    default = "tf-state-dyn-db-20220513"
}

variable "aws_region_zone02"{
    description = "AWS Zone"
    type = string
    default = "us-east-1b"
}

variable "aws_region_zone03"{
    description = "AWS Zone"
    type = string
    default = "us-east-1c"
}

variable "key_name"{
    description = "AWS EC2 Key Pair"
    type = string
    default = "acloud-tf-temp-key" 
}

variable "ami_rhel"{
    description = "Red Hat Linux 8 HVM"
    type = string
    default = "ami-06640050dc3f556bb"
}

variable "ami_ubuntu"{
    description = "Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2022-06-09"
    type = string
    default = "ami-052efd3df9dad4825"
}
