# AGENTS.md

This repository contains Terraform product modules for deploying Landscape, including the Landscape Server charm and other required applications, using the Terraform provider for Juju. AI agents can assist with:

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

### Pull Requests

- Titles should follow Conventional Commits.

### Testing

Before submitting changes:

1. Run `make fix` to format and lint code
2. Run `make test` to execute Terraform tests
3. Verify changes don't break existing functionality
4. Add tests in the `/tests` directory of the module being modified

### Documentation

- Don't manually update module README.md files when changing module interfaces; there's a GitHub Actions workflow (`.github/workflows/terraform-docs.yaml`) that uses terraform-docs to update the generated (API reference) portions of the README
- Keep examples up-to-date with code changes
- Follow the existing documentation style

