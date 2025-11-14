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

After deploying the module to the model, use the `juju status` command to monitor the lifecycle:

```sh
juju status -m landscape --relations --watch 2s
```

> [!TIP]
> Customize the module inputs with a `terraform.tfvars` file. An example is `terraform.tfvars.example`, which can be used after removing the `.example` extension.

## API

### Inputs

The Landscape Scalable product module offers the following configurable inputs:

| Name               | Type   | Description                                                                                                                           | Required | Default |
| ------------------ | ------ | ------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------- |
| `haproxy`          | object | Configuration for the HAProxy charm including app_name, channel, config, constraints, resources, revision, base, and units            | False    | `{}`    |
| `landscape_server` | object | Configuration for the Landscape Server charm including app_name, channel, config, constraints, resources, revision, base, and units   | False    | `{}`    |
| `model`            | string | The name of the Juju model to deploy Landscape Server to                                                                              | True     | -       |
| `postgresql`       | object | Configuration for the PostgreSQL machine charm including app_name, channel, config, constraints, resources, revision, base, and units | False    | `{}`    |
| `rabbitmq_server`  | object | Configuration for the RabbitMQ Server charm including app_name, channel, config, constraints, resources, revision, base, and units    | False    | `{}`    |

#### Nested object schemas

##### `landscape_server`

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
{ autoregistration = "true", landscape_ppa = "ppa:landscape/self-hosted-25.10" }
```

##### `postgresql`

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

##### `haproxy`

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

##### `rabbitmq_server`

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
{ consumer-timeout = "259200000" }
```

### Outputs

Upon being applied, the module exports the following outputs:

| Name                            | Description                                                                                                                                                               | Sensitive |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| `applications`                  | Map containing all applications (charms) in the module                                                                                                                    | False     |
| `admin_email`                   | The email of the first admin (if set).                                                                                                                                    | False     |
| `admin_password`                | The password of the first admin (if set).                                                                                                                                 | True      |
| `has_modern_amqp_relations`     | The deployment used the `inbound-amqp` and `outbound-amqp` endpoints to integrate the Landscape Server and RabbitMQ server charms rather than the legacy `amqp` endpoint. | False     |
| `has_modern_postgres_interface` | The deployment supports the `postgresql_client` charm interface and used the `database` endpoint when integrating Landscape Server and PostgreSQL.                        | False     |
| `registration_key`              | Registration key for Landscape Server clients                                                                                                                             | True      |
| `haproxy_self_signed`           | HAProxy is not using custom TLS.                                                                                                                                          | False     |

## Notes

- This module uses the [Landscape Server charm module](https://github.com/canonical/landscape-charm/tree/main/terraform)
