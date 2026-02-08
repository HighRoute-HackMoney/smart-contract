import { ethers } from "hardhat";

/**
 * Deploy the SessionSettlement contract to BNB testnet.
 */
async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with account:", deployer.address);
  console.log("Account balance:", (await ethers.provider.getBalance(deployer.address)).toString());

  const SessionSettlement = await ethers.getContractFactory("SessionSettlement");
  const settlement = await SessionSettlement.deploy();

  await settlement.waitForDeployment();

  const address = await settlement.getAddress();
  console.log("SessionSettlement deployed to:", address);

  // Save deployment info
  console.log("\nDeployment Info:");
  console.log("Contract Address:", address);
  console.log("Network:", (await ethers.provider.getNetwork()).name);
  console.log("Chain ID:", (await ethers.provider.getNetwork()).chainId);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
