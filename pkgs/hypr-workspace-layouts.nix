{
  lib,
  fetchFromGitHub,
  hyprland,
  hyprlandPlugins,
}:
hyprlandPlugins.mkHyprlandPlugin hyprland {
  pluginName = "hyprWorkspaceLayouts";
  version = "0-unstable-2024-07-21";

  src = fetchFromGitHub {
    owner = "zakk4223";
    repo = "hyprWorkspaceLayouts";
    rev = "2490e24048185840f0314306a10d64c16bff7857";
    hash = "sha256-pUYB2rDOpnxEbIQmj1R0WbfVhdbgxE8UKXtHi5/B59c=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv workspaceLayoutPlugin.so $out/lib/libhyprWorkspaceLayouts.so

    runHook postInstall
  '';

  meta = {
    description = "Per Workspace Layouts";
    homepage = "https://github.com/zakk4223/hyprWorkspaceLayouts/tree/main";
    license = lib.license.bsd3;
    platforms = lib.platforms.linux;
  };
}
