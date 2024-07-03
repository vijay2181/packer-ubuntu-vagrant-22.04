variable "headless_build" {
  type =  bool
  default = false
}

variable "memory_amount" {
  type =  string
  default = "4096"
}

  variable "user-ssh-password" {
  type = string
  sensitive = true
  default = "vagrant"
}

variable "build_artifact_location" {

 # If building on your local laptop use the ../build path
  type = string
  default = "../build/"
}

variable "db_user" {
    type = string
    default = "worker"
}

variable "db_pass" {
  type = string
  sensitive = true
  default = "vijay"
}

