
{ config, lib, pkgs, inputs, ... }: {

  home.packages = with pkgs; [
    chatgpt-cli
  ];

  xdg.configFile.chatgpt = {
    target = "chatgpt/config.json";
    source = ./config.json;
  };
}
