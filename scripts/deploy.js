const hre = require("hardhat");

async function main() {
  console.log("Deploying MedicalRecords contract...");

  const MedicalRecords = await hre.ethers.getContractFactory("MedicalRecords");
  const medicalRecords = await MedicalRecords.deploy();

  await medicalRecords.waitForDeployment();

  const address = await medicalRecords.getAddress();
  console.log("MedicalRecords deployed to:", address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
