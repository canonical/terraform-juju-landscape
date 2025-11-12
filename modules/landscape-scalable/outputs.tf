# © 2025 Canonical Ltd.

output "registration_key" {
  value = lookup(var.landscape_server.config, "registration_key", null)
}

output "admin_email" {
  value = lookup(var.landscape_server.config, "admin_email", null)
}

output "admin_password" {
  value     = lookup(var.landscape_server.config, "admin_password", null)
  sensitive = true
}

output "applications" {
  value = {
    landscape_server = module.landscape_server
    haproxy          = module.haproxy
    postgresql       = module.postgresql
    rabbitmq_server  = juju_application.rabbitmq_server
  }
}

locals {
  haproxy_self_signed = (
    lookup(var.haproxy.config, "ssl_key", null) == null ||
    lookup(var.haproxy.config, "ssl_cert", null) == null ||
    lookup(var.haproxy.config, "ssl_cert", null) == "SELFSIGNED"
  )
}

output "self_signed_server" {
  value = local.haproxy_self_signed ? true : false
}

output "has_modern_amqp_relations" {
  value = local.has_modern_amqp_relations
}

output "has_modern_postgres_interface" {
  value = local.has_modern_postgres_interface
}
