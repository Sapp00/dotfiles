#!/bin/bash

if [ -z "$1" ]; then
  echo "Please provide a name"
  exit 1
fi

NAME=$1

text="{ lib
, config
, ...
}:

with lib;

let
  cfg = config.module.${NAME};
in {
  options = {
    module.${NAME}.enable = mkEnableOption \"Enables ${NAME}\";
  };

  config = mkIf cfg.enable {
    programs.${NAME} = {
      enable = true;
    };
  };
}"

mkdir "./home-manager/modules/${NAME}";
echo "$text" > "./home-manager/modules/${NAME}/default.nix";
