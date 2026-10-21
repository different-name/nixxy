{ lib, bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "applications" "orca-slicer" ] {
  home-manager = { pkgs, osConfig, ... }: {
    keep.persist.packages.orca-slicer = {
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
                --set GALLIUM_DRIVER zink \
                --set WEBKIT_DISABLE_DMABUF_RENDERER 1
            '';
          }
        else
          pkgs.orca-slicer;

      xdg.cache.dirs."orca-slicer" = { };
      xdg.config.dirs."OrcaSlicer" = { };
      xdg.data.dirs."orca-slicer" = { };
    };
  };
}
