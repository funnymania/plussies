// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "hardhat/console.sol";

// What if you could associate an NFT as your most recent message.
// Then, this would be an onchain record of most recent NFTs associated
// with an address. Since this is just a string (JSON) can also be a msg.
contract Plussy {
  mapping(address => string) userCurrentContent;
  mapping(address => uint) userPlusCount;
  mapping(address => Constraint) userConstraints;

  struct Constraint {
    uint lastPlussed;
    address to;
  }

  constructor() {
    console.log("new life");
    console.log("we'd applaud a new life");
  }

  function updateContent(string content) public {
    userCurrentContent[msg.sender] = content;
  }

  function getContentByAddress(address artOwner) public view returns (string) {
    return userCurrentContent[artOwner]; 
  }


  function plusSomething(address content) public {
    uint threeDaysPrevious = now - (60 * 60 * 24 * 3);
    uint timeUntil = userConstraints[msg.sender].lastPlussed - threeDaysPrevious;
    require(userConstraints[msg.sender].lastPlussed > threeDaysPrevious, timeUntil + " until you can next plus.");
    require(content != msg.sender, "Can't plus yourself ;)");

     userPlusCount[content] += 1; 
     userConstraints[msg.sender].lastPlussed = now;
  }

  function getUserPlussies(address artOwner) public view returns (string) {
    return userPlusCount[artOwner];
  }
}
