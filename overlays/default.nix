{ ... }:
{
  modifications = final: prev: { };

  additions = final: prev: import ../pkgs { pkgs = final; };
}
