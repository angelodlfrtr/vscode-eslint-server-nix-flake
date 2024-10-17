{
  description = "VS Code ESLint LSP server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };

        src = pkgs.fetchFromGitHub {
          owner = "microsoft";
          repo = "vscode-eslint";
          rev = "d1b62dfd90f5929f54fd3a551a2b985b4cf1cdf5"; # After this rev (> v2.4.4), stop working wirth helix
          hash = "sha256-kqgIteDrcefrcLVNiVexdxlm4uEIAxSyDWp91bCLMhU=";
        };

        pname = "vscode-eslint-server";
        version = "3.0.10";
      in {
        packages.default = pkgs.buildNpmPackage {
          inherit pname version src;
          patches = [./package-lock.patch];
          npmDepsHash = "sha256-vVK7pbGhQ2+rNxJ4gVc/IRTl49yHZ4nlkJ/1XzhRLYs=";
          npmBuildScript = "webpack";

          buildInputs = [pkgs.nodejs];

          postBuild = ''
            mkdir -p $out/bin
            { echo '#!/usr/bin/env node '; cat ./server/out/eslintServer.js; } >./server/out/eslintServer.js.patched
            install -m755 -D ./server/out/eslintServer.js.patched $out/bin/vscode-eslint-server
          '';

          postFixup = ''
            rm -Rf $out/lib
          '';
        };
      }
    );
}
