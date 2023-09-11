import { ethers } from "hardhat";

async function main() {
  const
  [deployer] = await ethers.getSigners(),
  tweeter = await ethers.deployContract("Twitter_BUNN");

  await tweeter.waitForDeployment();

  console.log(`
  Tweeter deployed:

  contract address -> ${tweeter.target}

  deployer -> ${deployer.address}
  `);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
