#!/usr/bin/env bash

git_repo="bash-script-template"
git_user="firepress-org"
git_release_description="Refer to [CHANGELOG.md](https://github.com/"${user}"/"${git_repo}"/blob/master/CHANGELOG.md) for details about this release."
tag_version="$(git tag --sort=-creatordate | head -n1)"
gopath=$(go env GOPATH)

# meant to work on local setup
# on PROD, these are always gpg encrypted
export GITHUB_TOKEN="$(cat ~/secrets_open/token_github/token.txt)"
