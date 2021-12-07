# action-julia-docker

Create and publish a Docker image for a Julia application.

## Inputs

| Name | Description | Required | Default |
| ---- | ----------- | -------- | ------- |
| registry | Docker registry | false | ghcr.io |
| registry-username | Docker registry username | false | `${{ github.actor }}` |
| registry-password | Docker registry password | true | |
| image-name | Docker image name | false | `${{ github.repository }}` |
| julia-version | Julia version | true | |
| julia-org | GitHub organization providing the Julia package | false | `${{ github.actor }}` |
| julia-project | Julia package name | false | `${{ github.event.repository.name }}` |
| julia-branch | Branch of the Julia package | false | main |
| julia-run-script | Entrypoint script used to run the Julia package | false | scripts/docker_run.sh |
| ssh-private-key | SSH private key used to check out Julia repositories | true | |

## Outputs

| Name | Description | Format |
| ---- | ----------- | ------ |
| image-full-name | Full name of the Docker image with registry prefix | registry/owner/image |
| image-name | Name of the Docker image with owner prefix | owner/image |
| tags | Tags for the Docker image | v1,latest |

## Usage

```
name: Build and publish a Docker image

on:
  push:
    branches:
      - 'main'
    tags:
      - 'v*'
  pull_request:
    branches:
      - 'main'

jobs:
  build-and-push-image:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - name: Get branch name
        id: branch-name
        uses: tj-actions/branch-names@v5

      - name: Build and publish Julia application Docker image
        uses: chipkent/action-julia-docker@v1.0.3
        with:
          registry-password: ${{ secrets.GITHUB_TOKEN }}
          julia-version: 1.6
          julia-org: ${{ github.actor }}
          julia-project: ${{ github.event.repository.name }}
          julia-branch: ${{ steps.branch-name.outputs.current_branch }}
          ssh-private-key: ${{ secrets.SSH_PRIVATE_KEY }}
```