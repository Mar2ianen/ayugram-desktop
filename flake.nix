{
  description = "AyuGram Desktop";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    tg_owt = {
      url = "github:ndfined-crp/tg_owt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://mar2ianen-ayugram.cachix.org"
      "https://tg-owt.cachix.org"
    ];
    extra-trusted-public-keys = [
      "mar2ianen-ayugram.cachix.org-1:lBT/myHhswxz97HLBpkbF+4BWPxltMKoPnfs8Nnw6Q0="
      "tg-owt.cachix.org-1:lp0BukIhSK3EIyLcDhDZ5zABgT48nmNp6t4SnZ0wr8w="
    ];
  };
  outputs = inputs: let
    inherit (inputs) nixpkgs tg_owt;

    systems = ["x86_64-linux" "aarch64-linux"];
    forEachSystem = nixpkgs.lib.genAttrs systems;
  in {
    packages = forEachSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      ayugram-desktop = pkgs.kdePackages.callPackage ./default.nix {tg_owt = tg_owt.packages.${system}.default;};
      ayugram-desktop-debug = pkgs.kdePackages.callPackage ./default.nix {
        isDebug = true;
        tg_owt = tg_owt.packages.${system}.default;
      };
    in {
      inherit ayugram-desktop;
      inherit ayugram-desktop-debug;
      default = ayugram-desktop;
    });
  };
}
