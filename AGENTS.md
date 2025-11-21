# AGENTS.md

This repository welcomes contributions and interactions from AI agents.

## Overview

This repository contains Terraform product modules for deploying Landscape, including the Landscape Server charm and other required applications, using the Juju provider. AI agents can assist with:

- Code review and improvements
- Documentation updates
- Terraform module development
- Testing and validation
- Bug fixes and issue resolution

## Guidelines for AI Agents

### Code Modifications

When making code changes, AI agents should:

1. Follow Terraform best practices and conventions
2. Maintain consistency with existing module patterns
3. Ensure all changes are properly formatted using `make fix`
4. Validate configurations where possible
5. Update relevant documentation

### Testing

Before submitting changes:

1. Run `make fix` to format and lint code
2. Run `make test` to execute Terraform tests
3. Verify changes don't break existing functionality

### Documentation

- Update module README.md files when changing module interfaces
- Keep examples up-to-date with code changes
- Follow the existing documentation style

## Repository Structure

```
.
├── modules/
│   └── landscape-scalable/    # Terraform module for scalable Landscape deployment
├── CONTRIBUTING.md            # Contribution guidelines
├── README.md                  # Main repository documentation
└── Makefile                   # Build and test automation
```

## Prerequisites

Development requires:
- Juju >=3.6
- A Juju controller bootstrapped onto a machine cloud
- A Juju model available for testing
- Terraform or OpenTofu
- Make
- TFLint

## Resources

- [Terraform Documentation](https://www.terraform.io/)
- [Juju Provider Documentation](https://registry.terraform.io/providers/juju/juju/latest)
- [Contributing Guidelines](CONTRIBUTING.md)


