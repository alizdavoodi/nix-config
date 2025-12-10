{
  description = "A cross-platform flake for aichat (main branch)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    aichat-src = {
      url = "github:sigoden/aichat/4ddc28d40c238bb67d750d022bd3ca8a1a31cd0c";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      aichat-src,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        aichat = pkgs.rustPlatform.buildRustPackage {
          pname = "aichat";
          version = aichat-src.shortRev or "main";
          src = aichat-src;

          cargoLock = {
            lockFile = "${aichat-src}/Cargo.lock";
            allowBuiltinFetchGit = true;
          };

          nativeBuildInputs = with pkgs; [
            pkg-config
          ];

          buildInputs =
            with pkgs;
            [
              openssl
            ]
            ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
              libiconv
            ];

          doCheck = false;
        };
      in
      {
        packages = {
          default = aichat;
        };

        apps = {
          default = flake-utils.lib.mkApp {
            drv = aichat;
            exePath = "/bin/aichat";
          };
        };

        devShells.default = pkgs.mkShell { packages = [ aichat ]; };
      }
    );
}
