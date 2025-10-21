{
  lib,
  config,
  pkgs,
  ...
}:
let
  looking-glass-client-fixed = pkgs.looking-glass-client.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
    # steam-run workaround for imgui `FontData is incorrect, or FontNo cannot be found.`
    # __NV_DISABLE_EXPLICIT_SYNC=1 workaround for https://github.com/NVIDIA/egl-wayland/issues/149
    postFixup = (old.postFixup or "") + ''
      mv $out/bin/looking-glass-client $out/bin/.looking-glass-client-real
      makeWrapper ${lib.getExe config.programs.steam.package.run} $out/bin/looking-glass-client \
        --add-flags "$out/bin/.looking-glass-client-real" \
        --set __NV_DISABLE_EXPLICIT_SYNC 1
    '';
  });

  looking-glass-client-udev-rules = pkgs.stdenv.mkDerivation {
    pname = "looking-glass-client-udev-rules";
    inherit (pkgs.looking-glass-client) version;
    src = pkgs.writeTextDir "/99-kvmfr.rules" ''
      SUBSYSTEM=="kvmfr", OWNER="root", GROUP="kvm", MODE="0660"
    '';

    nativeBuildInputs = [
      pkgs.udevCheckHook
    ];

    doInstallCheck = true;
    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      mkdir -p $out/lib/udev/rules.d
      cp $src/99-kvmfr.rules $out/lib/udev/rules.d/
    '';
  };

  # rom files for pci passthrough
  ryzen-gpu-passthrough = pkgs.fetchFromGitHub {
    owner = "isc30";
    repo = "ryzen-gpu-passthrough-proxmox";
    rev = "46bf94d57f5ffc18cf38a4c4e5f0dde106ed99f4";
    hash = "sha256-mZc/gC4pjN3hkUFaVCoz1AXHSyEDgrt5MrlAHTbHBmc=";
  };
in
{
  dyad.programs.virt-manager.enable = true;

  boot = {
    kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
      ''vfio-pci.ids="1002:13c0,1002:1640"''
    ];
    initrd.kernelModules = [
      "vendor-reset"
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      "nvidia"
    ];
    blacklistedKernelModules = [
      "amdgpu"
    ];

    extraModulePackages = [
      config.boot.kernelPackages.vendor-reset
      # required kernel module for looking glass kvmfr
      config.boot.kernelPackages.kvmfr
    ];
    kernelModules = [ "kvmfr" ];
    extraModprobeConfig = "options kvmfr static_size_mb=128";
  };

  # https://looking-glass.io/docs/B7/ivshmem_kvmfr/#cgroups
  # found the defaults here, though they may be quite outdated
  # https://gist.github.com/marcolivierarsenault/07fda832a5c773944ff7#file-qemu-conf-L271-L277
  virtualisation.libvirtd.qemu.verbatimConfig = ''
    cgroup_device_acl = [
      "/dev/null",
      "/dev/full",
      "/dev/zero",
      "/dev/random",
      "/dev/urandom",
      "/dev/ptmx",
      "/dev/kvm",
      "/dev/kqemu",
      "/dev/rtc",
      "/dev/hpet",
      "/dev/vfio/vfio",
      "/dev/net/tun",
      "/dev/vfio/1",
      "/dev/kvmfr0",
    ]
  '';

  # used in vm config, like so
  /*
    <hostdev mode="subsystem" type="pci" managed="yes">
      ... (vga adapter)
      <rom file="/etc/libvirt/roms/vbios_9800x3d.bin"/>
    </hostdev>
    <hostdev mode="subsystem" type="pci" managed="yes">
      ... (soundcard)
      <rom file="/etc/libvirt/roms/AMDGopDriver_9800x3d.rom"/>
    </hostdev>
  */
  environment.etc = {
    "libvirt/roms/vbios_9800x3d.bin".source = ryzen-gpu-passthrough + /vbios_9800x3d.bin;
    "libvirt/roms/AMDGopDriver_9800x3d.rom".source = ryzen-gpu-passthrough + /AMDGopDriver_9800x3d.rom;
  };

  environment.systemPackages = [
    looking-glass-client-fixed
  ];

  services.udev.packages = [
    looking-glass-client-udev-rules
  ];
}
