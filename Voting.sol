// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract Voting is ERC20,Ownable,ReentrancyGuard {

    constructor() ERC20("Voting", "VT") {}

    function mint(address account, uint256 amount) public onlyOwner {  //creating tokens
        _mint(account, amount);
    }

    function getTokenBalance(address account) public view returns (uint256) {
    return balanceOf(account);
    }

    function transferToContract(uint256 amount) public {
    require(balanceOf(msg.sender) >= amount, "Not enough tokens");

    // Transfer tokens to contract
    transfer(address(this), amount);
    }





function deposit() external payable {
}

  
function withdraw(address payable _to, uint _amount) external nonReentrant onlyOwner{
    require(msg.sender == owner(), "Only the owner can withdraw funds");
        _to.transfer(_amount);
}

  

function getBalance() external view returns(uint){
        return address(this).balance;
} 

function getAddress() external view returns(address) {
    require(msg.sender == owner(), "Only the owner ");
        return address(this);
}

}