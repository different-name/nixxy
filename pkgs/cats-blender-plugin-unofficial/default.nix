{
  pkgs,
  sources,
  ...
}:
pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
  inherit (sources.cats-blender-plugin-unofficial) pname version src;

  installPhase = ''
    mkdir -p $out
    cp -r $src $out/cats-blender-plugin-unofficial
  '';

  blenderInstallPath = "4.4/extensions/user_default/cats_blender_plugin";
})
