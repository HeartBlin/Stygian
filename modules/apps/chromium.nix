{ pkgs, lib, ... }:

{
  environment.systemPackages = [
    (pkgs.chromium.override {
      enableWideVine = true;
      commandLineArgs = [
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
        "--enable-features=${lib.concatStringsSep "," [
          "AcceleratedVideoEncoder"
          "AcceleratedVideoDecodeLinuxGL"
          "AcceleratedVideoDecodeLinuxZeroCopyGL"
          "VaapiOnNvidiaGPUs"
          "VerticalTabs"
          "JXLImageFormat"
          "MiddleClickAutoscroll"
        ]}"
        "--disable-features=${lib.concatStringsSep "," [
          "WaylandWpColorManagerV1"
        ]}"
      ];
    })
  ];

  programs.chromium = {
    enable = true;
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
      "kpmjjdhbcfebfjgdnpjagcndoelnidfj" # Control Panel for Twitter
      "gphhapmejobijbbhgpjhcjognlahblep" # GNOME Shell integration
    ];

    extraOpts = {
      AIModeSettings = 1; # Disables AI Mode button
      PasswordManagerEnabled = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      EnableMediaRouter = false;
      SpellcheckEnabled = true;
      SpellcheckLanguage = [ "en-GB" "ro" ];
      BookmarkBarEnabled = false;
      ShowHomeButton = false;

      ExtensionInstallBlocklist = [ "*" ];
      ExtensionSettings = {
        "nngceckbapebfimnlniiiahkandclblb"."toolbar_pin" = "force_pinned";
        "ddkjiahejlhfcafbddmgiahcphecmpfh"."toolbar_pin" = "force_pinned";
      };

      "AutoSelectCertificateForUrls" = [
        (builtins.toJSON {
          pattern = "https://[*.]heartblin.eu";
          filter.ISSUER.CN = "Finality Intermediate CA";
        })
      ];
    };
  };
}
