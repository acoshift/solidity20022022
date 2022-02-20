import { ethers } from "hardhat"
import { TestToken__factory } from "../typechain"

async function main() {
  const signers = await ethers.getSigners()

  const TestToken = new TestToken__factory(signers[0])
  const testToken = await TestToken.deploy()
  await testToken.deployed()

  console.log("TestToken deployed to:", testToken.address)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
