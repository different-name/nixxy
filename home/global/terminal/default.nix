{
  pkgs,
  self,
  ...
}: {
  imports = [
    ./btop.nix
    ./fastfetch.nix
    ./fd.nix
    ./fish.nix
    ./fzf.nix
    ./git.nix
    ./kitty.nix
    ./yazi.nix
  ];

  home.packages =
    (with pkgs; [
      imagemagick
      ani-cli
      trashy
      ncdu
      vrc-get
      aspell
      aspellDicts.en
      libqalculate
      sshfs
      wl-clipboard
    ])
    ++ [
      self.inputs.hyprpicker.packages.${pkgs.system}.default
    ];
}
