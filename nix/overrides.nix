{ pkgs }:

self: super:

with { inherit (pkgs.stdenv) lib; };

with pkgs.haskell.lib;

{
  eq_ = (
    with rec {
      eq_Source = pkgs.lib.cleanSource ../.;
      eq_Basic  = self.callCabal2nix "eq_" eq_Source { };
    };
    overrideCabal eq_Basic (old: {
    })
  );
}
