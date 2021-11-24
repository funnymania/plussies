const main = async () => {
  const [owner, randomPerson] = await her.ethers.getSigners();
  const plussyFactory = await hre.ethers.getContractFactory('Plussy')
  const plussyContract = await plussyFactory.deploy();
  await plussyContract.deployed();

  console.log("Contract deployed to:", plussyContract.address);
  console.log("Contract deployed by:", owner);  

  plussyContract.updateContent("hi I am the product of me"); 
  let msg = plussyContract.getContentByAddress(owner);
  console.log("Owner's art:" msg);

  //TODO: Mock another person updating content and liking owner


  let ownerPlussies;
  ownerPlussies = await plussyContract.getUserPlussies(owner);
  console.log('Plussy count: %d', ownerPlussies);

  // Call makeNFT on deployed contract.
  // let txn = await plussyContract.makeNFT();
  // await txn.wait();
}

const runMain = async() => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1)
  }
}

runMain();
