{ root, ... }:
{
  perSystem = { self', pkgs, ... }:
    let
      wallpaper = "${root}/assets/chinatown.png";
    in
    {
      packages.dmenu = pkgs.dmenu.overrideAttrs (_: {
        patches = [
          "${root}/nix/pkgs/dmenu/dmenu-bar-height-5.2.diff"
          "${root}/nix/pkgs/dmenu/dmenu-gruvbox-20210329-9ae8ea5.diff"
        ];
      });

      packages.feh-wallpaper = pkgs.writeShellScriptBin "feh-wallpaper" ''
        exec ${pkgs.feh}/bin/feh --bg-fill ${wallpaper}
      '';

      # Default package: xmonad WM environment.
      packages.default = pkgs.symlinkJoin {
        name = "xmonad-config";
        paths = [
          self'.packages.xmonad-config
          self'.packages.dmenu
          self'.packages.feh-wallpaper
        ];
      };
    };
}
