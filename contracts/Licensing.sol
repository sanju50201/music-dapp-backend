// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract Licensing {
  struct MusicTrack {
    string title;
    string artist;
    uint256 price; // in wei
    bool isLicensed;
  }

  mapping(uint256 => MusicTrack) public musicTracks;
  mapping(address => uint256) public userLicenses;

  uint256 public totalTracks;

  event TrackUploaded(
    uint256 indexed trackId,
    string title,
    string artist,
    uint256 price
  );
  event TrackStreamed(address indexed user, uint256 trackId);
  event TrackLicensed(address indexed user, uint256 trackId);

  address public owner;

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only the owner has the access");
    _;
  }

  function uploadTrack(
    string memory title,
    string memory artist,
    uint256 price
  ) public onlyOwner {
    uint256 trackId = totalTracks;
    musicTracks[trackId] = MusicTrack({
      title: title,
      artist: artist,
      price: price,
      isLicensed: false
    });
    totalTracks++;
    emit TrackUploaded(trackId, title, artist, price);
  }

  function purchaseLicense(uint256 trackId) public payable {
    require(trackId < totalTracks, "Invalid Track ID.");
    MusicTrack storage track = musicTracks[trackId];
    require(!track.isLicensed, "Track is already Licensed");
    require(msg.value >= track.price, "Insufficient Funds!");

    track.isLicensed = true;
    userLicenses[msg.sender] = trackId;
    emit TrackLicensed(msg.sender, trackId);
  }

  function streamTrack() public {
    uint256 trackId = userLicenses[msg.sender];
    require(trackId < totalTracks, "No Valid License Found!");
    emit TrackStreamed(msg.sender, trackId);
  }

  function withdrawBalance() public onlyOwner {
    payable(owner).transfer(address(this).balance);
  }
}
