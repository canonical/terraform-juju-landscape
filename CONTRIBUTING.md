# Contributing

## Prerequisites

To make contributions to this repository, the following software is needed to be installed in your development environment. Please ensure the following are installed before development.

- Juju >=3.6
- A Juju controller bootstrapped onto a machine cloud
- Terraform
- A model for testing

## Development and Testing

The Terraform modules uses the Juju provider to provision Juju resources. Please refer to the [Juju provider documentation](https://registry.terraform.io/providers/juju/juju/latest/docs) for more information.

Make sure you have `terraform` installed:

```sh
sudo snap install terraform --classic
```

Then, in a product module directory, such as `modules/landscape-scalable`, initialise Terraform:

```sh
terraform init
```

Format the \*.tf files to a canonical format and style:

```sh
terraform fmt
```

Check the syntax:

```sh
terraform validate
```

Preview the changes:

```sh
terraform plan
```

## Lint and test

Install `tflint`:

```sh
sudo snap install tflint
```

Use the Make recipes:

```sh
make fix && make test
```
