{...}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "lov3g00d";
        email = "zamkovoy99@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
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
}
