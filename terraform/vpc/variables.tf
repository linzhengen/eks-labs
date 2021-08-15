variable "region" {
  default = "ap-northeast-1"
}

variable "cluster_name" {
  default = "test-eks"
}

variable "availability_zones" {
  default = ["ap-northeast-1d", "ap-northeast-1c", "ap-northeast-1a"]
}
