variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "products-api"
}

variable "lambda_runtime" {
  type    = string
  default = "python3.12"
}

variable "lambda_memory" {
  type    = number
  default = 256
}

variable "lambda_timeout" {
  type    = number
  default = 10
}

variable "common_tags" {
  type = map(string)

  default = {
    Environment = "dev"
    ManagedBy   = "terraform"
    Project     = "products-api"
    Owner       = "TatianaMotta"
  }
}
