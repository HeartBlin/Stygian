{
  boot = {
    tmp.useTmpfs = true;
    zswap = {
      dynamicSwap = true;
      enable = true;
      compressor = "zstd";
      maxPoolPercent = 20;
      shrinkerEnabled = true;
      acceptThresholdPercent = 90;
    };
  };
}
