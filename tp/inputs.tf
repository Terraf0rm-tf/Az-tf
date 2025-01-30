variable "nic_names" {
    type    = list(string)
    default = [ "nic1", "nic2" ] 
}

variable "web_subnet" {
    type    = string
    default = "web-sub"
}

variable "public_ip" {
    type = list(string)
    default = [ "Ip1", "Ip2" ]
}

variable "webserver_names" {
    type = list(string)
    default = [ "web", "app" ]
}