// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract Ownership is ERC721URIStorage, Ownable {
  struct MusicInfo {
    string title;
    string artist;
    string ipfsHash;
  }
  //   error OwnableInvalidOwner(address owner);

  mapping(uint256 => MusicInfo) private musicInfo;

  uint256 private tokenIdCounter = 0;
  event MusicUploaded(
    uint256 indexed tokenId,
    address indexed owner,
    string title,
    string artist,
    string ipfsHash
  );

  constructor(address initialOwner) ERC721("MusicOwnership", "MUSIC") {
    _transferOwnership(initialOwner);
  }

  function uploadMusic(
    string memory title,
    string memory artist,
    string memory ipfsHash
  ) public onlyOwner {
    uint256 tokenId = tokenIdCounter;
    _safeMint(msg.sender, tokenId);
    musicInfo[tokenId] = MusicInfo({
      title: title,
      artist: artist,
      ipfsHash: ipfsHash
    });
    tokenIdCounter++;
    emit MusicUploaded(tokenId, msg.sender, title, artist, ipfsHash);
  }

  function getMusicInfo(
    uint256 tokenId
  )
    public
    view
    returns (string memory title, string memory artist, string memory ipfsHash)
  {
    // require(ownerOf(tokenId), "Music does not exist");
    MusicInfo memory info = musicInfo[tokenId];
    return (info.title, info.artist, info.ipfsHash);
  }
}
