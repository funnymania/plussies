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
  address public lastPlussiedAddress;
  address public chosenPlussyAddress;

  uint MAX_SIZE = 200;
  uint lotteryFrequency = 1;
  uint lotteryPrize = 0.0001 ether;
  uint private rngSeed;

  // If plussy is on chain somewhere, provide its contract address, 
  // assuming it follows standards, should be able to find a plussy
  // associated with account.
  struct PlussyPower {
    address externalContractOfPlussy;
    string presentHere;
  }

  struct Constraint {
    uint lastPlussed;
    address to;
  }

  constructor() payable {
    userCurrentContent[msg.sender] = "new life; we'd applaud her new life";
    chosenPlussyAddress = msg.sender;
    rngSeed = (block.timestamp + block.difficulty) % 100;
  }

  function updateContent(string calldata content) public {
    if (bytes(content).length > MAX_SIZE) 
      revert PlussyOverCapacity(MAX_SIZE);

    userCurrentContent[msg.sender] = content;
    chosenPlussyAddress = msg.sender;
    emit AnewPlussy(chosenPlussyAddress, content);
  }

  function getLastPlussiedPlussy() public view returns (string memory, address) {
    return (userCurrentContent[lastPlussiedAddress], lastPlussiedAddress);
  }

  function getChosenPlussy() public view returns (string memory, address) {
    return (userCurrentContent[chosenPlussyAddress], chosenPlussyAddress);
  }

  function getPlussy(address artOwner) public view returns (string memory) {
    return userCurrentContent[artOwner]; 
  }

  error PlussyTooSoon(uint);
  error PlussyOverCapacity(uint);

  event AnewPlussy(address plussyPerson, string plussy);
  event Plussied(address plussier, string plussiedThing);
  event SomeonesLucky(address plussied, string plussy);

  function plusSomething(address content) public {
    uint timeRestriction = block.timestamp - (60 * 60 * 24);
    if (userConstraints[msg.sender].lastPlussed > timeRestriction) {
      uint timeUntil = userConstraints[msg.sender].lastPlussed - timeRestriction;
      revert PlussyTooSoon(timeUntil);
    }

    require(content != msg.sender, "Cant plus yourself ;)");

    userPlusCount[content] += 1; 
    userConstraints[msg.sender].lastPlussed = block.timestamp;

    // Reward user every plussy if they are lucky ;) 
    if (userPlusCount[content] % lotteryFrequency == 0) {
      rngSeed = (block.timestamp + block.difficulty + rngSeed) % 100; 
      
      if (rngSeed > 90) {
        console.log("%s wins.", content);
        require(lotteryPrize <= address(this).balance, "Cannot withdraw more than contract has in balance");
        (bool success, ) = (content).call{value: lotteryPrize}("");
        require(success, "Failed to withdraw from contract.");
        emit SomeonesLucky(content, userCurrentContent[content]);
      }
    }

    emit Plussied(content, userCurrentContent[content]);
  }

  function getUserPlussies(address artOwner) public view returns (uint) {
    return userPlusCount[artOwner];
  }
}
