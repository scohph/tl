import { ethers } from "hardhat";
import WHITELIST from "./merkle/merkleData.json";

async function main() {
  const vestingContractName = "TRLOOP Vesting Contract";
  const TrloopMerkleRoot = "";
  const TrloopTokenAddress = "";
  const ownerAddress = "";

  const Vesting = await ethers.getContractFactory("Vesting");
  const vesting = await Vesting.deploy(
    vestingContractName,
    TrloopMerkleRoot,
    TrloopTokenAddress,
    ownerAddress
  );
  await vesting.deployed();
  console.log("Vesting Contract Address : ", vesting.address);

  // EXAMPLE

  //   const user0 = "";
  //   // @ts-ignore
  //   const userProofs = WHITELIST.claims[user0];

  //   const claimableAmount = await vesting.calculateClaim(
  //     userProofs?.index,
  //     userProofs?.amount,
  //     user0,
  //     userProofs?.proof
  //   );
  //   const undrawedAmount = await vesting.getUndrawedAmount(
  //     userProofs.index,
  //     userProofs.amount,
  //     user0,
  //     userProofs.proof
  //   );

  //   const claimTokens = await vesting
  //     .connect(user0)
  //     .claimTokens(userProofs.index, userProofs.amount, userProofs.proof);
  //   await claimTokens.wait();
}
/**
npx hardhat run scripts/vestingDeploy.ts --network
*/

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
