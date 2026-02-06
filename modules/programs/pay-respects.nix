{ delib, ... }:
delib.module {
  name = "programs.pay-respects";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    programs.pay-respects.enable = true;
    # TODO: Maybe add `programs.pay-respects.aiIntegration` in the future?
    # NOTE: There's also `services.ollama` option for LLM backend.
  };

  home.ifEnabled = {
    programs.pay-respects.enable = true;
  };
}
