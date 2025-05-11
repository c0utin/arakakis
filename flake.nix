{
  description = "Zig development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            zig
            zls  # Zig Language Server

            # Optional development tools
            # lldb  # LLVM debugger
            # file  # File type analysis
            # hyperfine  # Benchmarking tool
          ];

          # Set environment variables for Zig's cache directories
          ZIG_LOCAL_CACHE_DIR = "/tmp/zig-cache";
          ZIG_GLOBAL_CACHE_DIR = "/tmp/zig-global-cache";

          # Optional: Configure ZLS settings
          ZLS_USE_COMPLETIONS = "1";
          ZLS_ENABLE_AUTOFIX = "1";

          shellHook = ''
            echo "Zig ${pkgs.zig.version} ready!"
            echo "ZLS ${pkgs.zls.version} installed"
          '';
        };
      });
}