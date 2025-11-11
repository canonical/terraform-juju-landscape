# © 2025 Canonical Ltd.

variable "model" {
  description = "The name of the Juju model to deploy Landscape Server to"
  type        = string
}

variable "landscape_server" {
  type = object({
    app_name = optional(string, "landscape-server")
    channel  = optional(string, "25.10/edge")
    config = optional(map(string), {
      autoregistration = true
      landscape_ppa    = "ppa:landscape/self-hosted-25.10"
    })
    constraints = optional(string, "arch=amd64")
    resources   = optional(map(string), {})
    revision    = optional(number)
    base        = optional(string, "ubuntu@22.04")
    units       = optional(number, 1)
  })
}

variable "postgresql" {
  type = object({
    app_name = optional(string, "postgresql")
    channel  = optional(string, "16/stable")
    config = optional(map(string), {
      plugin_plpython3u_enable     = true
      plugin_ltree_enable          = true
      plugin_intarray_enable       = true
      plugin_debversion_enable     = true
      plugin_pg_trgm_enable        = true
      experimental_max_connections = 500
    })
    constraints = optional(string, "arch=amd64")
    resources   = optional(map(string), {})
    revision    = optional(number)
    base        = optional(string, "ubuntu@24.04")
    units       = optional(number, 1)
  })
}

variable "haproxy" {
  type = object({
    app_name = optional(string, "haproxy")
    channel  = optional(string, "latest/edge")
    config = optional(map(string), {
      default_timeouts            = "queue 60000, connect 5000, client 120000, server 120000"
      global_default_bind_options = "no-tlsv10"
      services                    = ""
      ssl_cert                    = "SELFSIGNED"
    })
    constraints = optional(string, "arch=amd64")
    resources   = optional(map(string), {})
    revision    = optional(number)
    base        = optional(string, "ubuntu@22.04")
    units       = optional(number, 1)
  })
}

variable "rabbitmq_server" {
  type = object({
    app_name = optional(string, "rabbitmq-server")
    channel  = optional(string, "latest/edge")
    config = optional(map(string), {
      consumer-timeout = 259200000
    })
    constraints = optional(string, "arch=amd64")
    resources   = optional(map(string), {})
    revision    = optional(number)
    base        = optional(string, "ubuntu@24.04")
    units       = optional(number, 1)
  })
}
