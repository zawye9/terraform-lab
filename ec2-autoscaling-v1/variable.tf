variable "http-port" {
  type        = number
  default     = 80
  description = "http port"
}

variable "main" {
  type        = string
  default     = "vpc-8aa042ec"
  description = "aws main vpc"
}
variable image_id {
  type        = string
  default     = "ami-0e97ea97a2f374e3d"
  description = "description"
}


