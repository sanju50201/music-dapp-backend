const hre = require("hardhat");

async function main() {
  const UserRoles = await hre.ethers.getContractFactory("UserRoles");
  const userRoles = await UserRoles.deploy();

  await userRoles.waitForDeployment();

  console.log(`UserRoles deployed to: ${userRoles.target}`);
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.log(err);
    process.exit(1);
  });
