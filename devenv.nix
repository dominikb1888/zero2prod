{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.cargo-watch
    pkgs.cargo-tarpaulin
    pkgs.clippy
    pkgs.rustfmt
    pkgs.cargo-audit
  ];

  # https://devenv.sh/languages/
  languages.rust.enable = true;

  # https://devenv.sh/processes/
  processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  enterShell = ''
    hello
    git --version
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/pre-commit-hooks/
  pre-commit.hooks = {
    clippy.enable = true;
    clippy.packageOverrides.cargo = pkgs.cargo;
    clippy.packageOverrides.clippy = pkgs.clippy;
    # some hooks provide settings
    clippy.settings.allFeatures = true;
    cargo-check.enable = true;
    rustfmt.enable = true;
    cargo-audit = {
      enable = true;
      name = "cargo audit";
      description = "checks rust code for sec vulnerabilities";
      files = "\.mtl$";
      entry = "${pkgs.cargo-audit}/bin/cargo-audit";
    };
    cargo-tarpaulin = {
      enable = true;
      name = "cargo tarpaulin";
      description = "calculates code coverage of tests";
      files = "\.mtl$";
      entry = "${pkgs.cargo-tarpaulin}/bin/cargo-tarpaulin";
    };
  };

  # See full reference at https://devenv.sh/reference/options/
}
