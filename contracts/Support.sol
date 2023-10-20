// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./Token.sol";

contract ArtistSupport {
  Token public token;

  mapping(address => uint256) public artistBalances;

  event ArtistSupported(
    address indexed artists,
    address indexed fan,
    uint256 amount
  );

  constructor(address _tokenAddress) {
    token = Token(_tokenAddress);
  }

  function supportArtist(address artist, uint256 amount) public {
    require(amount > 0, "Support amount must be greater than 0");
    require(
      token.transferFrom(msg.sender, address(this), amount),
      "Token transfer failed."
    );
    artistBalances[msg.sender] += amount;

    emit ArtistSupported(artist, msg.sender, amount);
  }

  function withdrawArtistBalance() public {
    uint256 balance = artistBalances[msg.sender];
    require(balance > 0, "No Balance, fund your wallet!");

    artistBalances[msg.sender] = 0;
    require(token.transfer(msg.sender, balance), "Token transfer failed.");
  }
}
