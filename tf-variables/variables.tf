variable "instance_type" {
  description = "What type of instance do you want to create"
  type        = string

  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "Only t2.micro and t3.micro are allowed"
  }
}

variable "ec2_config" {
  description = "Root volume configuration"
  type = object({
    v_size = number
    v_type = string
  })

  default = {
    v_size = 20
    v_type = "gp3"
  }

  validation {
    condition     = var.ec2_config.v_size >= 8
    error_message = "Root volume size must be at least 8GB"
  }
}
