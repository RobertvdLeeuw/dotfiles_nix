{
  domain = "rvdlserver.nl";
  tailnet = "tail672432.ts.net";

  syncthing.devices = {
    server = "";
    desktop = "24PKA7Z-UWYQM46-UORQCZS-TKM3Z3F-YP2CL7Z-A5PTLI5-6EH5OKX-HZLMQAV";
    laptop = "J267XXP-JPQEOP7-D23EIG5-QU25QS2-Y2KLCBT-NSLSG4A-UWDAU5X-54S4UAV";
  };

  hosts = {
    server = {
      name = "nixos-homelab";
      tailscale = "";
      ssh-port = 8022;
    };
    rpi = {
      name = "nixos-rpi";
      ssh-port = 8022;
    };
  };
}
