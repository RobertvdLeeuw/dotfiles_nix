{
  config,
  pkgs,
  pkgs-ollama,
  inputs,
  ...
}:

{
  home.packages = with pkgs; [
    opencommit
    oterm
    opencode
  ];

  services.ollama = {
    enable = true;
    package = pkgs-ollama.ollama-rocm;
  };

  programs.aichat = {
    enable = true;
    settings = {
      model = "ollama:qwen3.5:9b-48k";
      clients = [
        {
          type = "openai-compatible";
          name = "ollama";
          api_base = "http://localhost:11434/v1";
          models = [
            {
              name = "qwen3.5:9b-48k";
              supports_function_calling = true;
            }
          ];
        }
      ];
    };
  };
}
