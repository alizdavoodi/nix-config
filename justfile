default:
  @just -g --list

system-info:
  @echo "This is an {{arch()}} machine".

# AWS: retrieve the identity of the current user/role
[group('aws')]
@aws-id:
  aws --no-cli-pager sts get-caller-identity

# AWS: SSO login
[group('aws')]
@aws-sso-login:
  aws sso login

# AWS: export aws crendentials from sso profile
[group('aws')]
aws-export-creds:
  @eval $(aws configure export-credentials --profile InfraOps-sympower --format env)

# AWS: Check identity and login if needed
[group('aws')]
@aws-check-and-login:
  #!/usr/bin/env sh
  if ! just aws-id > /dev/null 2>&1; then
    echo "AWS identity check failed. Running SSO login..."
    just -g aws-sso-login
    just -g aws-export-creds
  else
    echo "AWS identity check passed."
    just -g aws-id
    just -g aws-export-creds
  fi



############################################################################
#
#  NixOS Desktop
#
############################################################################

[group('nixos')]
nix-switch name:
  nix run home-manager -- switch --flake {{name}}
