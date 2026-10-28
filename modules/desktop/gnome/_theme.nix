# CSS tricks.
{ pkgs, ... }:

{
  _gnome = {
    extensions = [ pkgs.gnomeExtensions.user-themes ];
    dconf.user."org/gnome/shell/extensions/user-theme".name = "panel-fix";
  };

  # hjem.users.primaryUser.files.".themes/panel-fix/gnome-shell/gnome-shell.css".text = ''
  #   @import url("${pkgs.gnome-shell}/share/gnome-shell/theme/gnome-shell.css");
  #
  #   #panel .panel-button,
  #   #panel .panel-button .system-status-icon {
  #     color: #222222;
  #   }
  #
  #   .workspace-dot {
  #     background-color: #222222;
  #   }
  # '';
}
