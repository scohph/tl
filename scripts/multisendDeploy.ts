import { ethers } from "hardhat";
import { parseEther } from "viem";

async function main() {
  const Multisend = await ethers.getContractFactory("Multisend");
  const multisend = await Multisend.deploy();
  await multisend.deployed();
  console.log("Multisend Contract Address : ", multisend.address);

  // EXAMPLE

  //   const trloopContractAddress = "";
  //   const token = await ethers.getContractAt("TRLOOP", trloopContractAddress);
  //   await token.deployed();

  //   const List = [
  //     {
  //       recipient: "0xc4e3d4fEEeFA5646316F7413871f5Aba661a0462",
  //       amount: parseEther("100"),
  //     },
  //     {
  //       recipient: "0xc4e3d4fEEeFA5646316F7413871f5Aba661a0462",
  //       amount: parseEther("100"),
  //     },
  //     {
  //       recipient: "0xc4e3d4fEEeFA5646316F7413871f5Aba661a0462",
  //       amount: parseEther("100"),
  //     },
  //     {
  //       recipient: "0xc4e3d4fEEeFA5646316F7413871f5Aba661a0462",
  //       amount: parseEther("100"),
  //     },
  //     {
  //       recipient: "0xc4e3d4fEEeFA5646316F7413871f5Aba661a0462",
  //       amount: parseEther("100"),
  //     },
  //   ];
  //   const totalTokens = parseEther("500");

  //   const approve = await token.approve(multisend.address, totalTokens);
  //   await approve.wait();

  //   const sends = await multisend.batchTransfer(token.address, List);
  //   await sends.wait();
}

/**
npx hardhat run scripts/multisendDeploy.ts --network
*/

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
