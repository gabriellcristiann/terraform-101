variable "region" {
  description = "Define what region the instance will be deployed"
  default     = "us-east-2"

}

variable "name" {
  description = "Name if the application"
  default     = "server01"
}

variable "env" {
  description = "Environment of the application"
  default     = "dev"
}

variable "instance_type" {
  description = "AWS instance type defines the hardware configuration of the machine"
  default     = "t2.micro"
}

variable "repo" {
  description = "Repository of the application"
  default     = "https://github.com/gabriellcristiann/terraform-101"
}