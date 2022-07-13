// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract cryptoKids{

    address owner;


    constructor(){
        owner = msg.sender;
    }
    struct Kid{
        address payable walletAddress;
        string firstName;
        string lastName;
        uint releaseTime;
        uint amount;
        bool canWithdraw;
    }

    Kid[] public kids;

    modifier onlyOwner{
        require(msg.sender == owner, "you are not owner");
        _;
    }

    function addKids(address payable walletAddress,string memory firstName,string memory lastName,uint releaseTime,uint amount,bool canWithdraw) public onlyOwner {
        kids.push(Kid(
            walletAddress,
            firstName,
            lastName,
            releaseTime,
            amount,
            canWithdraw));
    }
    function balanceOf() public view returns(uint){
        return address(this).balance;
    }

    function deposit(address walletAddress) payable public{
        addtoKids(walletAddress);
    }

    function addtoKids(address walletAddress) private {
        for(uint i = 0; i < kids.length; i++){
            if(kids[i].walletAddress == walletAddress){
                kids[i].amount += msg.value;

            }
        }
    }
    function getIndex(address walletAddress) view private returns(uint) {

        for(uint i = 0; i < kids.length; i++){
            if(kids[i].walletAddress == walletAddress){
                return i;
            }

        }
        return 999;

    }

    function availabletoWithdraw(address walletAddress) public returns(bool){
        uint i = getIndex(walletAddress);
        require(block.timestamp > kids[i].releaseTime, "you cannot withdraw yet");

        if(block.timestamp > kids[i].releaseTime){
            kids[i].canWithdraw = true;
            return true;
        }else{
            return false;
        }
    }

    function withdraw(address walletAddress) payable public {
        uint i = getIndex(walletAddress);
        require(msg.sender == kids[i].walletAddress, "you must be kid to withdraw");
        require(kids[i].canWithdraw == true, "you cannot withdraw at this time");

        kids[i].walletAddress.transfer(kids[i].amount);
    }


}
