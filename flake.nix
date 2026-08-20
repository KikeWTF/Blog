{
  description = "Workspace development flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {self, ...} @ inputs: let
    inherit (inputs.nixpkgs) lib;
    systems = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    forEachSystem = supportedSystems: fn:
      lib.genAttrs supportedSystems (
        system:
          fn {
            inherit system;
            pkgs = import inputs.nixpkgs {
              inherit system;
              config.allowUnfree = true;
              config.allowDeprecatedx86_64Darwin = "force";
            };
          }
      );

    # nixpkgs#quarto (1.10.18) was built against a too-new pandoc (3.7.x).
    # Quarto still emits the legacy `syntax-highlighting` key/flag, but pandoc
    # 3.x renamed it to `highlight-style`, so every render dies with:
    #   Aeson exception: Error in $: Unknown option "syntax-highlighting"
    # Patch the bundled JS directly (postInstall) so `quarto` just works.
    quarto_ = pkgs:
      pkgs.quarto.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          sed -i 's/kSyntaxHighlighting = "syntax-highlighting"/kSyntaxHighlighting = "highlight-style"/' "$out/bin/quarto.js"
          sed -i 's/"--syntax-highlighting"/"--highlight-style"/g' "$out/bin/quarto.js"
        '';
      });
  in {
    # +------------- packages -------------+
    packages = forEachSystem systems ({pkgs, ...}: {
      default = quarto_ pkgs;
      quarto = quarto_ pkgs;
    });

    # +------------- development shells -------------+
    devShells = forEachSystem systems ({pkgs, ...}:
      let
        shell = pkgs.mkShell {
          name = "workspace";
          buildInputs = [
            (quarto_ pkgs)
          ];
          shellHook = "";
        };
      in {
        default = shell;
        dev = shell;
      });
  };
}
