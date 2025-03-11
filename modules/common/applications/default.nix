{
  lib,
  pkgs,
  ...
}: {
  imports = lib.custom.scanPaths ./.;

  config = {
    environment.systemPackages = with pkgs; [
      zen-browser
      mpv
    ];

    environment.etc."kolide-k2/secret" = {
      mode = "0600";
      text = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJvcmdhbml6YXRpb24iOiJuYWxpemkiLCJraWQiOiJiODoxZDowNjo5NzpjYjo3OTpjMDo3MTpjNDoxNTpjZDo5Yzo4Mjo0MDo4NjpjYSIsImNyZWF0ZWRBdCI6IjE3MzA1ODcwNjMiLCJjcmVhdGVkQnkiOiJrd29ya2VyIn0.mvjJdcI7yfypxER0IHr_HlhERYuuHa9jVNWDaogZ-5Lia4CS4SDUIIFrm9xVXHUP6xzdZjQqTVcj2QrootnKrq5WZxKrWLwbZci1NgAj4NJoildbJDFWXN8hPPRzlO9cc4ET8RZ-hG_-fXjjwdgWH_5iJ05a2JTDTCioCzdFn6XrpVFUBDDW5T_GxSCrR2xva4oTPqXHeAlK0zBq5IF2SGWCwZnj7UimnXmve2ET8OrIGg_j-V_nv-3tYFk7Qo8iUpqgpsnAS7Yytc1Ee5Jpaos1sCums5OkV6fQkZUTp-oVkUR6iE9YdcPAUNZ3vt4gUZugoBw787bjmzKtcGx-aQ";
    };
  };
}
