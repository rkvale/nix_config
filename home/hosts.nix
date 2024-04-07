{ config, pkgs, ... }:

{ networking.extraHosts = ''
  10.181.27.16 infra-ood001
'';
}
