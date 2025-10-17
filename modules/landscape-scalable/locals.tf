# © 2025 Canonical Ltd.
# See LICENSE file for licensing details.
locals {
  self_signed = (
    lookup(var.haproxy.config, "ssl_key", null) == null ||
    lookup(var.haproxy.config, "ssl_cert", null) == null ||
    lookup(var.haproxy.config, "ssl_cert", null) == "SELFSIGNED"
  )
  legacy_amqp = var.landscape_server.channel != "latest-stable/edge" || (var.landscape_server.revision != null && var.landscape_server.revision <= 141)
}
