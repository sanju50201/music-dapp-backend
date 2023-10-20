// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UserRoles {
  enum Role {
    Listener,
    Artist
  }

  struct UserInfo {
    Role role;
    bool isRegistered;
  }

  mapping(address => UserInfo) public users;

  event RoleAssigned(address indexed user, Role role);
  event UserRegistered(address indexed user);

  constructor() {
    // Deployer is assigned the role of an artist by default
    users[msg.sender] = UserInfo({role: Role.Artist, isRegistered: true});
    emit RoleAssigned(msg.sender, Role.Artist);
    emit UserRegistered(msg.sender);
  }

  modifier onlyListener() {
    require(users[msg.sender].role == Role.Listener, "User is not a listener");
    _;
  }

  modifier onlyArtist() {
    require(users[msg.sender].role == Role.Artist, "User is not an artist");
    _;
  }

  function register() public {
    require(!users[msg.sender].isRegistered, "User is already registered");
    users[msg.sender] = UserInfo({role: Role.Listener, isRegistered: true});
    emit RoleAssigned(msg.sender, Role.Listener);
    emit UserRegistered(msg.sender);
  }

  function assignRole(address user, Role role) public onlyArtist {
    require(users[user].isRegistered, "User is not registered");
    users[user].role = role;
    emit RoleAssigned(user, role);
  }
}
