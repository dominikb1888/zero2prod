{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  dotenv.enable = true;

  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.cargo-watch
    pkgs.cargo-tarpaulin
    pkgs.clippy
    pkgs.rustfmt
    pkgs.cargo-audit
    pkgs.cargo-expand
    pkgs.sqlx-cli
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    pkgs.libiconv
    pkgs.darwin.apple_sdk.frameworks.SystemConfiguration
    pkgs.darwin.CF
    pkgs.darwin.Security
    pkgs.darwin.configd
    pkgs.darwin.dyld
  ];

  # https://devenv.sh/languages/
  languages.rust.enable = true;

  # https://devenv.sh/processes/
  processes.cargo-watch.exec = "cargo-watch -x run";

  # https://devenv.sh/services/
  services.postgres = {
    enable = true;
    listen_addresses = "localhost";
    port = 5432;
    initialScript = "CREATE DATABASE zero2prod;";
    #initialDatabases = [ { name = "newsletter"; } ];
  };

  # https://devenv.sh/scripts/
  scripts.init_db.exec = "scripts/init_db.sh";

  enterShell = ''
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
    # cargo-audit = {
    #   enable = true;
    #   name = "cargo audit";
    #   description = "checks rust code for sec vulnerabilities";
    #   files = "";
    #   entry = "${pkgs.cargo-audit}/bin/cargo-audit";
    # };
    # cargo-tarpaulin = {
    #   enable = true;
    #   name = "cargo tarpaulin";
    #   description = "calculates code coverage of tests";
    #   files = "";
    #   entry = "${pkgs.cargo-tarpaulin}/bin/cargo-tarpaulin";
    # };
  };

  # See full reference at https://devenv.sh/reference/options/
}
