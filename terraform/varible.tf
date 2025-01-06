variable "aws_access_key" {
  type        = string
  description = "aws access key"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "aws secret key"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "aws region"
  default     = "us-east-1"
}
