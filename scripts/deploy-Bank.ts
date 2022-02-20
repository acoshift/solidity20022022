import { ethers, run } from "hardhat"
import { Bank__factory } from "../typechain"

async function main() {
  const signers = await ethers.getSigners()

  const Bank = new Bank__factory(signers[0])
  const bank = await Bank.deploy()
  await bank.deployed()

  console.log("Bank deployed to:", bank.address)

  let tx = await bank.setFee('100')
  await tx.wait()

  // tx = await bank.transferOwnership('0x00000000000000000000')
  // await tx.wait()

  await run("verify:verify", {
    address: bank.address,
    constructorArguments: [],
    // contract: 'contracts/Bank.sol:Bank'
  })
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
