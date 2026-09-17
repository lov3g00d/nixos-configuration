{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Intercepting proxies
    burpsuite
    zap
    caido-desktop

    # Web scanning & fuzzing
    nuclei
    ffuf
    feroxbuster
    sqlmap
    dalfox
    nikto
    wpscan
    whatweb
    wafw00f
    seclists

    # Recon (ProjectDiscovery suite + friends)
    subfinder
    httpx
    katana
    dnsx
    naabu
    amass
    gau
    gospider

    # Network analysis
    termshark
    tcpdump
    bettercap
    masscan
  ];
}
