{ config, pkgs, ... }:
let 
  rocmpkgs = with pkgs.rocmPackages; [
      clr
      hipblas
      hipcub
      hipfft
      hipsolver
      hipsparse
      miopen
      rocm-smi
      rccl
      rocblas
      rocthrust
    ];
in
{
  nixpkgs.config.rocmSupport = true;

  # Install ROCm as a hardware module instead of manually symlinked packages
  hardware.graphics.extraPackages = rocmpkgs;

  # Create a compatibility symlink for tools that expect ROCm in /opt/rocm
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm   -    -    -     -    ${pkgs.rocmPackages.rocminfo}"
  ];

  # Adding the HIP compiler
  environment.variables = {
    "HIP_PATH" = "${pkgs.rocmPackages.clr}";
    "HSA_PATH" = "${pkgs.rocmPackages.rocm-runtime}";
  };

  environment = {
    # pathsToLink = [ "" ];
    systemPackages = rocmpkgs;
}
