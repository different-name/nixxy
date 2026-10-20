{
  users = {
    diffy = {
      # keep-sorted start
      argon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGSNVe+NarhPICWaIGLhPFnA9p3BX4WRDN4IHJJxuMnF diffy@argon";
      lithium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBky+9o1dDMAQ52WKsy+NU2yLEN04Cm5zSuaeJ24jx5e diffy@lithium";
      potassium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID3EOgPFHT/t5cimzbfL/vEyolU4CbdT9HVMyp8PnTUG diffy@potassium";
      sodium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIoe3VveHt2vXoHdkRbLE0Xx5il0T3v8PiWxFvdniSLg diffy@sodium";
      # keep-sorted end
    };

    # used by the nix daemon for remote builds
    root = {
      potassium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHsxVRPHU7NetTLDygkO4QZJV7PUwwv17gPHqmTQpzzM root@potassium";
      sodium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcwUucfJukMLcfKPpPnfzrw7lIIJFcwW/IxIIO6w8g7 root@sodium";
    };
  };
  hosts = {
    # keep-sorted start
    argon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAi8jyg0hGO5zjRDz+q04HyeNRx2Hj59gDMJLpXNrQtr";
    potassium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKs1Zcik4LOkXFf9Ty0xaaAoQLp1160S9ZQiraucxfV/";
    sodium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM9oz3SDojEZqnsBoYXOjdMGzyz3ILY7Luvfw7sTFm3/";
    # keep-sorted end
  };
}
