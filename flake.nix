{
  description = "Application packaged using poetry2nix";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.poetry2nix = {
    url = "github:nix-community/poetry2nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    poetry2nix,
  }:
    {
      # Nixpkgs overlay providing the application
      overlay = nixpkgs.lib.composeManyExtensions [
        poetry2nix.overlay
        (final: prev: {
          # The application
          myapp = prev.poetry2nix.mkPoetryApplication {
            projectDir = ./.;
            preferWheels = true;
            # overrides = poetry2nix.overrides.defaultPoetryOverrides;
            overrides = (
              self: super: {
                django-stubs-ext = super.django-stubs-ext.overridePythonAttrs (
                  old: {
                    prePatch = "";
                  }
                );
              }
            );
            groups = ["dev"];
          };
          myenv = prev.poetry2nix.mkPoetryEnv {
            projectDir = ./.;
            preferWheels = true;
            # overrides = poetry2nix.overrides.defaultPoetryOverrides;
            overrides = (
              self: super: {
                django-stubs-ext = super.django-stubs-ext.overridePythonAttrs (
                  old: {
                    prePatch = "";
                  }
                );
              }
            );
            groups = ["dev"];
          };
        })
      ];
    }
    // (
      flake-utils.lib.eachDefaultSystem (
        system: let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [self.overlay];
          };
        in {
          apps = {
            myapp = pkgs.myapp;
          };

          defaultApp = pkgs.myapp;

          devShell = pkgs.mkShell {
            buildInputs = [pkgs.python310 pkgs.poetry pkgs.myenv];
          };
          # devShell = pkgs.myapp.dependencyEnv.overrideAttrs (oldAttrs: {buildInputs = [pkgs.poetry];});
        }
      )
    );
}
