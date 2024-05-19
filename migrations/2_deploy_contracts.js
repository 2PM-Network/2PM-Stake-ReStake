const StakingContract = artifacts.require("StakingContract");

module.exports = function(deployer) {
  const stETHAddress = "0x0000000000000000000000000000000000000000"; // 替换为实际的stETH合约地址
  const rETHAddress = "0x0000000000000000000000000000000000000000"; // 替换为实际的rETH合约地址
  const eigenlayerAddress = "0x0000000000000000000000000000000000000000"; // 替换为实际的Eigenlayer合约地址

  deployer.deploy(StakingContract, stETHAddress, rETHAddress, eigenlayerAddress);
};
