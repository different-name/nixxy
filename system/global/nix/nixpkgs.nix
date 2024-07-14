{
  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      # (final: prev: {
      #   blender = prev.blender.overrideAttrs (old: {
      #     version = "3.6.13";
      #     src = fetchurl {
      #       url = "https://download.blender.org/source/blender-3.6.13.tar.xz";
      #       hash = "";
      #     };
      #   });
      # })
    ];
  };
}
