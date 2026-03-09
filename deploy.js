const hre = require("hardhat");

async function main() {
  const baseURI = "ipfs://QmYourHashHere/";
  const NFT = await hre.ethers.getContractFactory("NFTCollection");
  const nft = await NFT.deploy(baseURI);

  await nft.deployed();
  console.log("NFT Collection deployed to:", nft.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
