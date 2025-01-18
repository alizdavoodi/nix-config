{
  description = "A cross-platform flake for aichat";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Define reusable variables
        version = "v0.26.0";
        repoOwner = "sigoden";
        repoName = "aichat";
        repoUrl =
          "https://github.com/${repoOwner}/${repoName}/releases/download/${version}";

        # Map system types to the corresponding platform-specific suffix
        platformSuffixes = {
          "aarch64-darwin" = "aarch64-apple-darwin";
          "x86_64-darwin" = "x86_64-apple-darwin";
          "x86_64-linux" = "x86_64-unknown-linux-musl";
          "aarch64-linux" = "aarch64-unknown-linux-musl";
        };

        # Single hash for all assets
        assetHash =
          "sha256-1Fp9QdU/K2d4ztEief3ezE6S7gUOCiY2FA6MdcBLmSQ="; # Replace with the actual hash

        # Select the appropriate platform suffix based on the system
        platformSuffix =
          platformSuffixes.${system} or (throw "Unsupported system: ${system}");

        # Construct the asset filename dynamically
        assetFilename = "aichat-${version}-${platformSuffix}.tar.gz";

        # Construct the full URL for the pre-built asset
        assetUrl = "${repoUrl}/${assetFilename}";

        # Fetch the pre-built asset
        aichatAssets = pkgs.fetchurl {
          url = assetUrl;
          sha256 = assetHash;
        };

        # Create a custom derivation
        aichat = pkgs.stdenv.mkDerivation {
          name = "aichat";
          src = aichatAssets;

          dontUnpack = true;
          installPhase = ''
            mkdir -p $out/bin

            # Extract the binary directly from the tarball
            tar -xzf $src -C $out/bin

            # Ensure the binary is executable
            chmod +x $out/bin/aichat
          '';
        };
      in {
        packages = { default = aichat; };

        apps = {
          default = flake-utils.lib.mkApp {
            drv = aichat;
            exePath =
              "/bin/aichat"; # Adjust if the executable has a different name
          };
        };

        devShells.default = pkgs.mkShell { packages = [ aichat ]; };
      });
}

