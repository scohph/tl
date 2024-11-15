import { ethers } from "hardhat";

async function main() {
  const tokenOwnerAddress = "";
  const Trloop = await ethers.getContractFactory("TRLOOP");
  const trloop = await Trloop.deploy(tokenOwnerAddress);
  await trloop.deployed();
  console.log("TRLOOP Contract Address : ", trloop.address);
}
/**
npx hardhat run scripts/tokenDeploy.ts --network
*/

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
