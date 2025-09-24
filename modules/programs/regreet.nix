{...}: {
  #services.greetd = {
  #  enable = true;
  #  greeterManagesPlymouth = true;
  #};

  #programs.regreet = {
  #  enable = true;
  #  cageArgs = [
  #    # Allow TTY switching
  #    "-s"
  #    # Only display on the monitor last connected
  #    "-m"
  #    "last"
  #  ];
  #};
}
