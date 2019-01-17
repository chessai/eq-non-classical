{ pkgs }:

self: super:

with { inherit (pkgs.stdenv) lib; };

with pkgs.haskell.lib;

{
  eq-non-classical = (
    with rec {
      eq-non-classicalSource = pkgs.lib.cleanSource ../.;
      eq-non-classicalBasic  = self.callCabal2nix "eq-non-classical" eq-non-classicalSource { };
    };
    overrideCabal eq-non-classicalBasic (old: {
    })
  );
}
