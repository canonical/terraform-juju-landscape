# Landscape Server Terraform Product Module

This project contains the [Terraform][Terraform] product module to deploy the [Landscape Server bundle][Landscape Server bundle].

The module use the [Terraform Juju provider][Terraform Juju provider] to model the bundle deployment onto any machine environment managed by [Juju][Juju].

In order to deploy the Landscape Server product module, please follow the instructions in the `README.md` of the module.

## Linting

Use the following Make recipe to lint the modules:

```sh
make fmt-fix
```

## Testing

Use the following Make recipe to run the tests in the module(s):

```sh
make test
```

[Terraform]: https://www.terraform.io/
[Terraform Juju provider]: https://registry.terraform.io/providers/juju/juju/latest
[Juju]: https://juju.is
[Landscape Server bundle]: https://github.com/canonical/landscape-charm/blob/main/bundle-examples/bundle.yaml
