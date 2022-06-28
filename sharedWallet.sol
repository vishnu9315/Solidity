// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract sharedWallet{

    address public _owner;

    mapping(address => uint) public _owners;

    constructor(){
        _owner = msg.sender;
    }

    modifier owneronly{
        require(msg.sender == _owner);
        _;
    }
    modifier validOwner() {
        require(msg.sender == _owner || _owners[msg.sender] == 1);
        _;
    }

    event DepositFunds(address from, uint amount);
    event WithdrawFunds(address from, uint amount);
    event TransferFunds(address from, address to, uint amount);


    function addOwner(address owner) owneronly public{
        _owners[owner] = 1;
    }

    function removeOwner(address owner) owneronly public {
        _owners[owner] = 0;
    }

    function Deposit() external payable {

        emit DepositFunds(msg.sender, msg.value);

    }

    function withdraw(uint amount) validOwner public {
        require(address(this).balance >= amount);
        payable(msg.sender).transfer(amount);
        emit WithdrawFunds(msg.sender, amount);

    }

    function transfer(address payable to, uint amount) validOwner public {
        require(address(this).balance >= amount);
        to.transfer(amount);

        emit TransferFunds(msg.sender, to, amount);
    }

    function fund() validOwner public view returns(uint){
        return address(this).balance;
    }


}
