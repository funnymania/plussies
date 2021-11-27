const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const plussyFactory = await hre.ethers.getContractFactory('Plussy')
  const plussyContract = await plussyFactory.deploy({
    value: hre.ethers.utils.parseEther('0.1'),
  });
  await plussyContract.deployed();

  console.log("Contract deployed to:", plussyContract.address);
  console.log("Contract deployed by:", owner.address);  

  plussyContract.updateContent("hi I am the product of me"); 
  let msg = await plussyContract.getPlussy(owner.address);
  console.log("Owner's art:", msg);

  try {
    await plussyContract.plusSomething(owner.address);
  } catch (error) {
    console.log(error);
  }

  let ownerPlussies;
  ownerPlussies = await plussyContract.getUserPlussies(owner.address);
  console.log('Owner\'s plussy count: %d', ownerPlussies);

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
