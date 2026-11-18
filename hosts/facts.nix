{
  domain = "rvdlserver.nl";
  tailnet = "tail672432.ts.net";

  syncthing.devices = {
    server = "J2TMKWI-DQJY6VG-LJQD4QP-D4XKLPB-CKD4KMJ-7J5E5TO-EEGS5UW-E6C2BAH";
    desktop = "24PKA7Z-UWYQM46-UORQCZS-TKM3Z3F-YP2CL7Z-A5PTLI5-6EH5OKX-HZLMQAV";
    laptop = "J267XXP-JPQEOP7-D23EIG5-QU25QS2-Y2KLCBT-NSLSG4A-UWDAU5X-54S4UAV";
  };

  hosts = {
    server = {
      lan = "192.168.2.111";
      tailscale = "100.79.157.102";
      ssh-port = 8022;
    };
    rpi = {
      lan = "192.168.2.59";
      ssh-port = 8022;
    };
  };
}
