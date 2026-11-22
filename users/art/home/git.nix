{
  lib,
  osConfig,
  ...
}:
let
  gitProfiles = {
    personal = {
      name = "lov3g00d";
      email = "zamkovoy99@gmail.com";
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOVXe0NilOBtIVdsGEdw3Uis4W2i+BDSkTY4icKtm1g8";
    };
    myle = {
      name = "lov3g00d";
      email = "zamkovoy99@gmail.com";
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOVXe0NilOBtIVdsGEdw3Uis4W2i+BDSkTY4icKtm1g8";
    };
    opsfleet = {
      name = "artemzamkovyi";
      email = "artem.zamkovyi@opsfleet.com";
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPFpkppTMiBoUZPt2rKFXq0tH1KWe9IrgwBM+RItZva";
    };
  };
  defaultProfile = gitProfiles.personal;
in
{
  programs.git = {
    enable = true;
    signing = {
      key = defaultProfile.signingKey;
      signByDefault = true;
      allowedSigners = lib.concatLines (
        lib.unique (lib.mapAttrsToList (_: p: ''${p.email} namespaces="git" ${p.signingKey}'') gitProfiles)
      );
    };
    settings = {
      user = {
        name = defaultProfile.name;
        email = defaultProfile.email;
      };
      init.defaultBranch = "main";
      commit.verbose = true;
      pull.rebase = true;
      push.autoSetupRemote = true;
      fetch.prune = true;
      rebase.autoSquash = true;
      rebase.autoStash = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      diff.algorithm = "histogram";
      gpg.format = "ssh";
      "gpg \"ssh\"".program = "${osConfig.programs._1password-gui.package}/bin/op-ssh-sign";
    };
    includes = [
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
      {
        condition = "gitdir:~/Projects/opsfleet/";
        contents = {
          user = {
            name = gitProfiles.opsfleet.name;
            email = gitProfiles.opsfleet.email;
            signingkey = gitProfiles.opsfleet.signingKey;
          };
          url."git@github.com-opsfleet:".insteadOf = "git@github.com:";
        };
      }
    ];
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*.compute.internal *.googleapis.com compute.*" = {
        IdentityFile = "~/.ssh/google_compute_engine";
        StrictHostKeyChecking = "accept-new";
        UserKnownHostsFile = "~/.ssh/known_hosts_cloud";
        SetEnv = {
          TERM = "xterm-256color";
        };
      };
      "github.com-opsfleet" = {
        HostName = "github.com";
        User = "git";
        IdentityAgent = "~/.1password/agent.sock";
        IdentityFile = "~/.ssh/opsfleet_id_ed25519.pub";
        IdentitiesOnly = "yes";
      };
      "*" = {
        AddKeysToAgent = "yes";
        IdentityAgent = "~/.1password/agent.sock";
        SetEnv = {
          TERM = "xterm-256color";
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
    vault = "OpsFleet"
  '';
}
