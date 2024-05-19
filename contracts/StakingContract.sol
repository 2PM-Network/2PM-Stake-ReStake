// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

interface IEigenlayer {
    function delegate(address delegatee, uint256 amount) external;
}

contract StakingContract {
    IERC20 public stETH;
    IERC20 public rETH;
    IEigenlayer public eigenlayer;

    struct Stake {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => Stake) public stETHStakes;
    mapping(address => Stake) public rETHStakes;
    mapping(address => Stake) public ethDelegations;

    event Staked(address indexed user, uint256 amount, string tokenType);
    event Delegated(address indexed user, uint256 amount);

    constructor(address _stETH, address _rETH, address _eigenlayer) {
        stETH = IERC20(_stETH);
        rETH = IERC20(_rETH);
        eigenlayer = IEigenlayer(_eigenlayer);
    }

    function stakeStETH(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(stETH.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        stETHStakes[msg.sender] = Stake(amount, block.timestamp);
        emit Staked(msg.sender, amount, "stETH");
    }

    function stakeRETH(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(rETH.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        rETHStakes[msg.sender] = Stake(amount, block.timestamp);
        emit Staked(msg.sender, amount, "rETH");
    }

    function delegateETH(uint256 amount) external payable {
        require(amount > 0, "Amount must be greater than 0");
        require(msg.value == amount, "ETH amount mismatch");

        eigenlayer.delegate(address(this), amount);
        ethDelegations[msg.sender] = Stake(amount, block.timestamp);
        emit Delegated(msg.sender, amount);
    }

    function getStakedStETH(address user) external view returns (uint256) {
        return stETHStakes[user].amount;
    }

    function getStakedRETH(address user) external view returns (uint256) {
        return rETHStakes[user].amount;
    }

    function getDelegatedETH(address user) external view returns (uint256) {
        return ethDelegations[user].amount;
    }
}
