async function main() {
  const admin = '0xA7823936F974e2a996FdF25B5E36DeA29A5B52E1';
  const token = '0x71cb21900FD56cc13A58Dee9D07d5a0DB5Cc45bF';
  const Token = await ethers.getContractFactory('TokenSale');
  const contract = await Token.deploy(admin, token);

  console.log('Contract deployed at:', contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
