async function main() {
  let admin = '0xA7823936F974e2a996FdF25B5E36DeA29A5B52E1';
  let tokenAddress = '0xEe01acA23F80291F9eB3B8E3de1D177Af85c339f';
  const Token = await ethers.getContractFactory('TokenSale');
  const contract = await Token.deploy(admin, tokenAddress);

  console.log('Contract deployed at:', contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
