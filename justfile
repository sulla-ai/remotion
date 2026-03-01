set shell := ["bash", "-euo", "pipefail", "-c"]
set dotenv-load := true

registry := "ghcr.io"
owner := "sulla-ai"
image := "remotion"
full_image := registry + "/" + owner + "/" + image

default:
  @just --list

# Login to GitHub Container Registry (requires GITHUB_TOKEN)
gh-login:
  test -n "${GITHUB_TOKEN:-}" || (echo "GITHUB_TOKEN is required (set it in .env or environment)" && exit 1)
  echo "$GITHUB_TOKEN" | docker login {{registry}} -u "${GITHUB_USER:-${USER}}" --password-stdin

# Build an image tag. Usage: just build 2026.03
build tag="latest":
  docker build -t {{full_image}}:{{tag}} .

# Push an image tag. Usage: just push 2026.03
push tag="latest":
  docker push {{full_image}}:{{tag}}

# Build + push one tag. Usage: just publish 2026.03
publish tag="latest":
  docker build -t {{full_image}}:{{tag}} .
  docker push {{full_image}}:{{tag}}

# Build + push both a version tag and latest.
# Usage: just release 2026.03
release version:
  docker build -t {{full_image}}:{{version}} -t {{full_image}}:latest .
  docker push {{full_image}}:{{version}}
  docker push {{full_image}}:latest

# Show configured image coordinates
image-info:
  @echo "{{full_image}}"
