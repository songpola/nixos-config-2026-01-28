{ delib, ... }:
delib.module {
  name = "xdg";

  home.always = {
    # This will also add XDG_* environment variables
    xdg.enable = true;
  };
}
