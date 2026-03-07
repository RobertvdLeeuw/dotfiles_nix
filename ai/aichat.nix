{
  config,
  pkgs,
  inputs,
  ...
}:

{
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
