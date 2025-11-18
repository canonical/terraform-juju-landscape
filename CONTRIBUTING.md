# Contributing

## Prerequisites

To make contributions to this repository, the following software is needed to be installed in your development environment. Please ensure the following are installed before development.

- Juju >=3.6
- A Juju controller bootstrapped onto a machine cloud
- A Juju model available for testing
- Terraform or OpenTofu
- Make
- [TFLint](https://github.com/terraform-linters/tflint)

## Local development

The Terraform modules use the Terraform provider for Juju to provision Juju resources. Please refer to the [Juju provider documentation](https://documentation.ubuntu.com/terraform-provider-juju/latest/) for more information.

In a product module directory, such as `modules/landscape-scalable`, initialize Terraform:

```sh
terraform init
```

Then, modify `terraform.tfvars.example` per `variables.tf` to pass the model name and customize the module. 

Preview the changes:

```sh
terraform plan
```

If everything looks okay, apply the plan to deploy Landscape:

```sh
terraform apply
```

## Linting and running tests

You can use the Make recipes to check the affect of your changes on the modules.

Lint:

```sh
make fix
```

Run tests:

```sh
make test
```
