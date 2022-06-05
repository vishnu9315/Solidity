// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract voting {
    address public contractOwner;

    address[] public parties;

    mapping(address => uint) public votesReceived;
    address public winner;
    uint public winnerVotes;

    enum setStatus { Notstarted,running, completed }
    setStatus public status;
    constructor(){
        contractOwner = msg.sender;


    }

    modifier onlyOwner{
        require(msg.sender == contractOwner);
        _;
    }

    function Status() onlyOwner public {

        if(status != setStatus.running && status != setStatus.completed){
            status = setStatus.running;
        }
        else{
            status = setStatus.completed;
        }

    }

    function registerCanditate(address _canditate) onlyOwner public{
        parties.push(_canditate);
    }

    function vote(address _canditate) public {
        require(validateUser(_canditate), "Not a Valid Canditate");
        require(status == setStatus.running, "Voting has completed");

        votesReceived[_canditate] += 1;
    }

    function validateUser(address _canditate) public view returns(bool){

        for(uint i = 0; i < parties.length; i++){
            if(parties[i] == _canditate){
                return true;
            }
        }
        return false;
    }

    function voteCount(address _canditate) public view returns(uint){
        require(validateUser(_canditate), "Not a Valid Canditate");
        assert(status == setStatus.running);
        return votesReceived[_canditate];
    }

    function result() public {
        require(status == setStatus.completed, "Still in progress, voting has not been completed yet");
        for(uint i = 0; i < parties.length; i++){
            if(votesReceived[parties[i]] > winnerVotes){
                winnerVotes = votesReceived[parties[i]];
                winner = parties[i];
            }
        }
    }

}
