# Landscape Scalable Product Module

This module requires a bootstrapped Juju cloud with a model created within it, the name of which can be provided as `model`.

For example, bootstrap a LXD cloud:

```sh
juju bootstrap lxd landscape-controller
```

Then, create a model named `landscape`:

```sh
juju add-model landscape
```

Then, use `landscape` as the value for `model`:

```sh
terraform apply -var model=landscape
```

Example output:

```hcl
applications = {
  "haproxy" = {
    "app_name" = "haproxy"
    "provides" = {
      "cos_agent" = "cos-agent"
      "haproxy_route" = "haproxy_route"
      "ingress" = "ingress"
    }
    "requires" = {
      "certificates" = "certificates"
      "reverseproxy" = "reverseproxy"
    }
  }
  "landscape_server" = {
    "app_name" = "landscape-server"
    "provides" = {
      "cos_agent" = "cos-agent"
      "data" = "data"
      "hosted" = "hosted"
      "nrpe_external_master" = "nrpe-external-master"
      "website" = "website"
    }
    "requires" = {
      "application_dashboard" = "application-dashboard"
      "database" = "database"
      "db" = "db"
      "inbound_amqp" = "inbound-amqp"
      "outbound_amqp" = "outbound-amqp"
    }
  }
  "postgresql" = {
    "application_name" = "postgresql"
    "provides" = {
      "cos_agent" = "cos-agent"
      "database" = "database"
    }
    "requires" = {
      "certificates" = "certificates"
      "s3_parameters" = "s3-parameters"
    }
  }
  "rabbitmq_server" = {
    "charm" = tolist([
      {
        "base" = "ubuntu@24.04"
        "channel" = "latest/edge"
        "name" = "rabbitmq-server"
        "revision" = 250
        "series" = "noble"
      },
    ])
    "config" = tomap({
      "consumer-timeout" = "259200000"
    })
    "constraints" = "arch=amd64"
    "endpoint_bindings" = toset(null) /* of object */
    "expose" = tolist([])
    "id" = "landscape:rabbitmq-server"
    "machines" = toset([
      "2",
    ])
    "model" = "landscape"
    "model_type" = "iaas"
    "name" = "rabbitmq-server"
    "placement" = "2"
    "principal" = tobool(null)
    "resources" = tomap(null) /* of string */
    "storage" = toset(null) /* of object */
    "storage_directives" = tomap(null) /* of string */
    "trust" = false
    "units" = 1
  }
}
haproxy_self_signed = true
has_modern_amqp_relations = true
has_modern_postgres_interface = true
```

After deploying the module to the model, use the `juju status` command to monitor the lifecycle:

```sh
juju status -m landscape --relations --watch 2s
```

> [!TIP]
> Customize the module inputs with a `terraform.tfvars` file. An example is `terraform.tfvars.example`, which can be used after removing the `.example` extension.

## Requirements

| Name          | Version |
| ------------- | ------- |
| terraform     | >= 1.10 |
| juju provider | < 1.0.0 |

<!-- TODO: Just link to public Landscape docs rather than duplicate here. -->

## Inputs

The Landscape Scalable product module offers the following configurable inputs:

| Name               | Type   | Description                                                                                                                           | Required | Default |
| ------------------ | ------ | ------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------- |
| `haproxy`          | object | Configuration for the HAProxy charm including app_name, channel, config, constraints, resources, revision, base, and units            | False    | `{}`    |
| `landscape_server` | object | Configuration for the Landscape Server charm including app_name, channel, config, constraints, resources, revision, base, and units   | False    | `{}`    |
| `model`            | string | The name of the Juju model to deploy Landscape Server to                                                                              | True     | -       |
| `postgresql`       | object | Configuration for the PostgreSQL machine charm including app_name, channel, config, constraints, resources, revision, base, and units | False    | `{}`    |
| `rabbitmq_server`  | object | Configuration for the RabbitMQ Server charm including app_name, channel, config, constraints, resources, revision, base, and units    | False    | `{}`    |

### Nested object schemas

#### `landscape_server`

| Name          | Type        | Description                                    | Required | Default            |
| ------------- | ----------- | ---------------------------------------------- | -------- | ------------------ |
| `app_name`    | string      | Name of the application in the Juju model      | False    | `landscape-server` |
| `channel`     | string      | The channel to use when deploying the charm    | False    | `25.10/edge`       |
| `config`      | map(string) | Application config                             | False    | See below          |
| `constraints` | string      | Juju constraints to apply for this application | False    | `arch=amd64`       |
| `resources`   | map(string) | Charm resources                                | False    | `{}`               |
| `revision`    | number      | Revision number of the charm                   | False    | `null` (latest)    |
| `base`        | string      | The operating system on which to deploy        | False    | `ubuntu@22.04`     |
| `units`       | number      | Number of units to deploy                      | False    | `1`                |

Default `config`:

```hcl
{
  autoregistration = "true",
  landscape_ppa    = "ppa:landscape/self-hosted-25.10"
}
```

#### `postgresql`

| Name          | Type        | Description                                    | Required | Default         |
| ------------- | ----------- | ---------------------------------------------- | -------- | --------------- |
| `app_name`    | string      | Name of the application in the Juju model      | False    | `postgresql`    |
| `channel`     | string      | The channel to use when deploying the charm    | False    | `14/stable`     |
| `config`      | map(string) | Application config                             | False    | See below       |
| `constraints` | string      | Juju constraints to apply for this application | False    | `arch=amd64`    |
| `resources`   | map(string) | Charm resources                                | False    | `{}`            |
| `revision`    | number      | Revision number of the charm                   | False    | `null` (latest) |
| `base`        | string      | The operating system on which to deploy        | False    | `ubuntu@22.04`  |
| `units`       | number      | Number of units to deploy                      | False    | `1`             |

Default `config`:

```hcl
{
  plugin_plpython3u_enable     = "true"
  plugin_ltree_enable          = "true"
  plugin_intarray_enable       = "true"
  plugin_debversion_enable     = "true"
  plugin_pg_trgm_enable        = "true"
  experimental_max_connections = "500"
}
```

#### `haproxy`

| Name          | Type        | Description                                    | Required | Default         |
| ------------- | ----------- | ---------------------------------------------- | -------- | --------------- |
| `app_name`    | string      | Name of the application in the Juju model      | False    | `haproxy`       |
| `channel`     | string      | The channel to use when deploying the charm    | False    | `latest/edge`   |
| `config`      | map(string) | Application config                             | False    | See below       |
| `constraints` | string      | Juju constraints to apply for this application | False    | `arch=amd64`    |
| `resources`   | map(string) | Charm resources                                | False    | `{}`            |
| `revision`    | number      | Revision number of the charm                   | False    | `null` (latest) |
| `base`        | string      | The operating system on which to deploy        | False    | `ubuntu@22.04`  |
| `units`       | number      | Number of units to deploy                      | False    | `1`             |

Default `config`:

```hcl
{
  default_timeouts            = "queue 60000, connect 5000, client 120000, server 120000"
  global_default_bind_options = "no-tlsv10"
  services                    = ""
  ssl_cert                    = "SELFSIGNED"
}
```

#### `rabbitmq_server`

| Name          | Type        | Description                                    | Required | Default           |
| ------------- | ----------- | ---------------------------------------------- | -------- | ----------------- |
| `app_name`    | string      | Name of the application in the Juju model      | False    | `rabbitmq-server` |
| `channel`     | string      | The channel to use when deploying the charm    | False    | `latest/edge`     |
| `config`      | map(string) | Application config                             | False    | See below         |
| `constraints` | string      | Juju constraints to apply for this application | False    | `arch=amd64`      |
| `resources`   | map(string) | Charm resources                                | False    | `{}`              |
| `revision`    | number      | Revision number of the charm                   | False    | `null` (latest)   |
| `base`        | string      | The operating system on which to deploy        | False    | `ubuntu@24.04`    |
| `units`       | number      | Number of units to deploy                      | False    | `1`               |

Default `config`:

```hcl
{
  consumer-timeout = "259200000"
}
```

## Outputs

Upon being applied, the module exports the following outputs:

| Name                            | Description                                                                                                                                                               | Sensitive |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| `applications`                  | Map containing all applications (charms) in the module                                                                                                                    | False     |
| `admin_email`                   | The email of the first admin (if set).                                                                                                                                    | False     |
| `admin_password`                | The password of the first admin (if set).                                                                                                                                 | True      |
| `has_modern_amqp_relations`     | The deployment used the `inbound-amqp` and `outbound-amqp` endpoints to integrate the Landscape Server and RabbitMQ server charms rather than the legacy `amqp` endpoint. | False     |
| `has_modern_postgres_interface` | The deployment supports the `postgresql_client` charm interface and used the `database` endpoint when integrating Landscape Server and PostgreSQL.                        | False     |
| `registration_key`              | Registration key for Landscape Server clients                                                                                                                             | True      |
| `haproxy_self_signed`           | HAProxy is using a self-signed certificate.                                                                                                                               | False     |

## Notes

- This module uses the [Landscape Server charm module](https://github.com/canonical/landscape-charm/tree/main/terraform)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_juju"></a> [juju](#requirement\_juju) | < 1.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_juju"></a> [juju](#provider\_juju) | < 1.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_haproxy"></a> [haproxy](#module\_haproxy) | git::https://github.com/canonical/haproxy-operator.git//terraform/charm | rev250 |
| <a name="module_landscape_server"></a> [landscape\_server](#module\_landscape\_server) | git::https://github.com/jansdhillon/landscape-charm.git//terraform | update-tf-module |
| <a name="module_postgresql"></a> [postgresql](#module\_postgresql) | git::https://github.com/canonical/postgresql-operator.git//terraform | 16/edge |

## Resources

| Name | Type |
|------|------|
| [juju_application.rabbitmq_server](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.landscape_server_haproxy](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.landscape_server_inbound_amqp](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.landscape_server_outbound_amqp](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.landscape_server_postgresql](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.landscape_server_rabbitmq_server](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_haproxy"></a> [haproxy](#input\_haproxy) | Configuration for the HAProxy charm. | <pre>object({<br/>    app_name = optional(string, "haproxy")<br/>    channel  = optional(string, "latest/edge")<br/>    config = optional(map(string), {<br/>      default_timeouts            = "queue 60000, connect 5000, client 120000, server 120000"<br/>      global_default_bind_options = "no-tlsv10"<br/>      services                    = ""<br/>      ssl_cert                    = "SELFSIGNED"<br/>    })<br/>    constraints = optional(string, "arch=amd64")<br/>    resources   = optional(map(string), {})<br/>    revision    = optional(number)<br/>    base        = optional(string, "ubuntu@22.04")<br/>    units       = optional(number, 1)<br/>  })</pre> | `{}` | no |
| <a name="input_landscape_server"></a> [landscape\_server](#input\_landscape\_server) | Configuration for the Landscape Server charm. | <pre>object({<br/>    app_name = optional(string, "landscape-server")<br/>    channel  = optional(string, "25.10/edge")<br/>    config = optional(map(string), {<br/>      autoregistration = "true"<br/>      landscape_ppa    = "ppa:landscape/self-hosted-25.10"<br/>    })<br/>    constraints = optional(string, "arch=amd64")<br/>    resources   = optional(map(string), {})<br/>    revision    = optional(number)<br/>    base        = optional(string, "ubuntu@22.04")<br/>    units       = optional(number, 1)<br/>  })</pre> | `{}` | no |
| <a name="input_model"></a> [model](#input\_model) | The name of the Juju model to deploy Landscape Server to. | `string` | n/a | yes |
| <a name="input_postgresql"></a> [postgresql](#input\_postgresql) | Configuration for the PostgreSQL charm. | <pre>object({<br/>    app_name = optional(string, "postgresql")<br/>    channel  = optional(string, "14/stable")<br/>    config = optional(map(string), {<br/>      plugin_plpython3u_enable     = "true"<br/>      plugin_ltree_enable          = "true"<br/>      plugin_intarray_enable       = "true"<br/>      plugin_debversion_enable     = "true"<br/>      plugin_pg_trgm_enable        = "true"<br/>      experimental_max_connections = "500"<br/>    })<br/>    constraints = optional(string, "arch=amd64")<br/>    resources   = optional(map(string), {})<br/>    revision    = optional(number)<br/>    base        = optional(string, "ubuntu@22.04")<br/>    units       = optional(number, 1)<br/>  })</pre> | `{}` | no |
| <a name="input_rabbitmq_server"></a> [rabbitmq\_server](#input\_rabbitmq\_server) | Configuration for the RabbitMQ charm. | <pre>object({<br/>    app_name = optional(string, "rabbitmq-server")<br/>    channel  = optional(string, "latest/edge")<br/>    config = optional(map(string), {<br/>      consumer-timeout = "259200000"<br/>    })<br/>    constraints = optional(string, "arch=amd64")<br/>    resources   = optional(map(string), {})<br/>    revision    = optional(number)<br/>    base        = optional(string, "ubuntu@24.04")<br/>    units       = optional(number, 1)<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_email"></a> [admin\_email](#output\_admin\_email) | Administrator email from the Landscape Server config. |
| <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password) | Administrator password from the Landscape Server config. |
| <a name="output_applications"></a> [applications](#output\_applications) | The charms included in the module. |
| <a name="output_haproxy_self_signed"></a> [haproxy\_self\_signed](#output\_haproxy\_self\_signed) | Indicates whether HAProxy is using a self-signed TLS certificate. |
| <a name="output_has_modern_amqp_relations"></a> [has\_modern\_amqp\_relations](#output\_has\_modern\_amqp\_relations) | Indicates whether the deployment uses the modern inbound/outbound AMQP endpoints. |
| <a name="output_has_modern_postgres_interface"></a> [has\_modern\_postgres\_interface](#output\_has\_modern\_postgres\_interface) | Indicates whether the deployment uses the modern database interface for PostgreSQL. |
| <a name="output_registration_key"></a> [registration\_key](#output\_registration\_key) | Registration key from the Landscape Server config. |
<!-- END_TF_DOCS -->