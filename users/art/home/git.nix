{
  pkgs,
  config,
  ...
}: let
  gitProfiles = {
    personal = {
      name = "lov3g00d";
      email = "zamkovoy99@gmail.com";
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOVXe0NilOBtIVdsGEdw3Uis4W2i+BDSkTY4icKtm1g8";
    };
    platonic = {
      name = "artem-platonic";
      email = "artem@platonic.io";
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDggqFZHQRloncjP5kxBYOEqCizWPemTjvdqDsEk8yjJ";
    };
    myle = {
      name = "lov3g00d";
      email = "zamkovoy99@gmail.com";
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOVXe0NilOBtIVdsGEdw3Uis4W2i+BDSkTY4icKtm1g8";
    };
  };
  defaultProfile = gitProfiles.personal;
in {
  programs.git = {
    enable = true;
    signing = {
      key = defaultProfile.signingKey;
      signByDefault = true;
    };
    settings = {
      user = {
        name = defaultProfile.name;
        email = defaultProfile.email;
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      gpg.format = "ssh";
      "gpg \"ssh\"".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
    };
    includes = [
      {
        condition = "gitdir:~/Projects/platonic/";
        contents = {
          user = {
            name = gitProfiles.platonic.name;
            email = gitProfiles.platonic.email;
            signingkey = gitProfiles.platonic.signingKey;
          };
        };
      }
      {
        condition = "gitdir:~/Projects/myle/";
        contents = {
          user = {
            name = gitProfiles.myle.name;
            email = gitProfiles.myle.email;
            signingkey = gitProfiles.myle.signingKey;
          };
        };
      }
    ];
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "github.com-platonic" = {
        hostname = "github.com";
        user = "git";
        identitiesOnly = true;
        identityFile = "~/.ssh/platonic.pub";
        extraOptions = {
          IdentityAgent = "~/.1password/agent.sock";
        };
      };
      "*.compute.internal *.googleapis.com compute.*" = {
        identityFile = "~/.ssh/google_compute_engine";
        extraOptions = {
          StrictHostKeyChecking = "no";
          UserKnownHostsFile = "/dev/null";
          SetEnv = "TERM=xterm-256color";
        };
      };
      "*" = {
        addKeysToAgent = "yes";
        extraOptions = {
          IdentityAgent = "~/.1password/agent.sock";
          SetEnv = "TERM=xterm-256color";
        };
      };
    };
  };

  programs.delta = {
    enable = true;
    options = {
      navigate = true;
      side-by-side = true;
      line-numbers = true;
    };
  };

  home.file.".config/1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    vault = "Personal"

    [[ssh-keys]]
    vault = "Platonic"
  '';

  home.file.".ssh/platonic.pub".text = "${gitProfiles.platonic.signingKey}";
}
