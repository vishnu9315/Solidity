// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract HotelBooking{

    enum Status{ vacant, occupied}

    Status currentStatus;

    event occupy(address _occupant, uint _value);

    address payable public owner;

    constructor() {
        owner == msg.sender;
        currentStatus = Status.vacant;

    }

    modifier onlyWhileVacant {
        require(currentStatus == Status.vacant, "room has been occupied");
        _;
    }

    modifier cost(uint _amount){
        require(msg.value >= _amount, "not enough ether provided");
        _;
    }

    receive() external payable onlyWhileVacant cost(2 ether){
        currentStatus = Status.occupied;
        owner.transfer(msg.value);
        emit occupy(msg.sender ,msg.value);
    }
}
