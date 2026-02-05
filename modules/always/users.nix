{
  homeManagerUser,
  ...
}:
{
  users.users.${homeManagerUser} = {
    isNormalUser = true;
    uid = 1000;
    # Default to private group instead of shared "users" group
    group = homeManagerUser;
    extraGroups = [
      "users"
      "wheel"
    ];
  };

  users.groups.${homeManagerUser}.gid = 1000;
}
