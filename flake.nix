{
  description = "VS Code ESLint LSP server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
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
          rev = "b8734bc05119619447a5caf8af0d082cffdec9bb";
          hash = "sha256-+KDuITtKD7xcoK2L9Pg+Hg+9TGp3Z6TCEKJ4HSN5ZJM=";
        };

        pname = "vscode-eslint-server";
        version = "3.0.10";
      in {
        packages.default = pkgs.buildNpmPackage {
          inherit pname version src;
          patches = [./package-lock.patch];
          npmDepsHash = "sha256-MgCUhjIEGnJ+3ezyEBt1znWtgGoI2bx02w2DkDcj9VM=";
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
