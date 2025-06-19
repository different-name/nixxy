{
  sources,
  lib,
  stdenvNoCC,
  ...
}:
stdenvNoCC.mkDerivation {
  inherit (sources.cats-blender-plugin-unofficial) pname version src;

  installPhase = ''
    mkdir -p $out
    cp -r $src/. $out/share/
  '';

  blenderInstallPath = "4.4/extensions/user_default/cats_blender_plugin";

  meta = {
    description = "A continuation of the Cats Blender Plugin which is tool designed to shorten steps needed to import and optimize models into VRChat. Compatible models are: MMD, XNALara, Mixamo, DAZ/Poser, Blender Rigify, Sims 2, Motion Builder, 3DS Max and potentially more, originally by absolute-quantum. Not Official";
    homepage = "https://github.com/teamneoneko/Cats-Blender-Plugin-Unofficial-";
    license = lib.licenses.gpl3Only;
    mainProgram = "cats-blender-plugin-unofficial";
    platforms = lib.platforms.all;
  };
}
