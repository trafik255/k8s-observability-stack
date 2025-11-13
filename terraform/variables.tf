variable "aws_region" {
  type        = string
  default     = "us-east-2"
  description = "AWS region for deployment"
}

variable "cluster_name" {
  type        = string
  default     = "observability-eks"
  description = "EKS cluster name"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.10.0.0/16"
  description = "VPC CIDR block"
}
