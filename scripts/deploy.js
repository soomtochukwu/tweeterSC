"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const hardhat_1 = require("hardhat");
async function main() {
    const [deployer] = await hardhat_1.ethers.getSigners(), tweeter = await hardhat_1.ethers.deployContract("Twitter_BUNN");
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
