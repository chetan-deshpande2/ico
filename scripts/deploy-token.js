async function main() {
  const Token = await ethers.getContractFactory('Token');
  const contract = await Token.deploy();

  console.log('Contract deployed at:', contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
