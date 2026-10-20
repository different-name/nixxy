{ lib, bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "applications" "orca-slicer" ] {
  home-manager = { pkgs, osConfig, ... }: {
    home.perpetual.default.packages.orca-slicer = {
      package =
        if lib.elem "nvidia" osConfig.services.xserver.videoDrivers then
          # blank viewport on nvidia proprietary gl, same env as withNvidiaGLWorkaround without the rebuild
          pkgs.symlinkJoin {
            name = "orca-slicer";
            paths = [ pkgs.orca-slicer ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/orca-slicer \
                --set __GLX_VENDOR_LIBRARY_NAME mesa \
                --set __EGL_VENDOR_LIBRARY_FILENAMES /run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json \
                --set MESA_LOADER_DRIVER_OVERRIDE zink \
                --set GALLIUM_DRIVER zink
            '';
          }
        else
          pkgs.orca-slicer;

      dirs = [
        # keep-sorted start
        "$cacheHome/orca-slicer"
        "$configHome/OrcaSlicer"
        "$dataHome/orca-slicer"
        # keep-sorted end
      ];
    };
  };
}
