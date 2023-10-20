// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract PaymentSharing {
  address public owner;

  struct MusicTrack {
    string title;
    string artist;
    uint256 price;
    address owner;
  }

  MusicTrack[] public musicTracks;

  mapping(address => uint256[]) public userPurchasedTracks;
  uint256 public totalRevenue;

  event TrackUploaded(
    uint256 indexed trackId,
    string title,
    string artist,
    uint256 price,
    address owner
  );
  event TrackPurchased(address indexed user, uint256 trackId);
  event RevenueDistributed(address indexed artist, uint256 amount);

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Not the Owner");
    _;
  }

  function uploadTrack(
    string memory title,
    string memory artist,
    uint256 price
  ) public {
    uint256 trackId = musicTracks.length;
    musicTracks.push(
      MusicTrack({
        title: title,
        artist: artist,
        price: price,
        owner: msg.sender
      })
    );
    emit TrackUploaded(trackId, title, artist, price, msg.sender);
  }

  function purchaseTrack(uint256 trackId) public payable {
    require(trackId < musicTracks.length, "Invalid track ID");
    MusicTrack storage track = musicTracks[trackId];
    require(
      !isUserOwnerOfTrack(trackId, msg.sender),
      "User already owns the track"
    );
    require(msg.value >= track.price, "Insufficient payment");

    payable(track.owner).transfer(msg.value);
    userPurchasedTracks[msg.sender].push(trackId);
    totalRevenue += msg.value;

    emit TrackPurchased(msg.sender, trackId);
    distributeRevenue(track.owner, msg.value);
  }

  function distributeRevenue(address artist, uint256 amount) internal {
    uint256 artistShare = (amount * 85) / 100; // 85% to the artist
    payable(artist).transfer(artistShare);

    uint256 platformShare = amount - artistShare; // 15% to the platform
    emit RevenueDistributed(artist, artistShare);
    emit RevenueDistributed(owner, platformShare);
  }

  function isUserOwnerOfTrack(
    uint256 trackId,
    address user
  ) public view returns (bool) {
    MusicTrack storage track = musicTracks[trackId];
    return user == track.owner;
  }
}
