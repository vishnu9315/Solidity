// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract Lottery {

    address payable[] public players;

    address public owner;

    constructor(){
        owner = msg.sender;

    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    function depositMoney() public payable {
        require(msg.value >= 2 ether);

        players.push(payable(msg.sender));
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,players.length)));
    }

    function pickWinner() onlyOwner public {
        uint randomNumber = random();
        uint index = randomNumber % players.length;

        address payable winner;

        winner = players[index];
        winner.transfer(address(this).balance);

        players = new address payable[](0);


    }


    }
