// SPDX-License-Identifier: aIT
pragma solidity >=0.5.0 <0.9.0;

interface ERC20 {
function totalSupply() external view returns (uint256);
function balanceOf(address tokenOwner) external view returns (uint);
function allowance(address tokenOwner, address spender) external view returns (uint);
function transfer(address to, uint tokens) external returns (bool);
function approve(address spender, uint tokens)  external returns (bool);
function transferFrom(address from, address to, uint tokens) external returns (bool);
event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
event Transfer(address indexed from, address indexed to, uint tokens);
}

contract myErc20Token is ERC20 {
    mapping(address => uint) public _balances;

    mapping(address => mapping(address => uint)) _allowed;

    string public name = "Vishnu20";
    string public symbol = "Vs";
    uint public decimal = 0;

    uint public _totalsupply;

    address public _creator;

    constructor(){
        _creator = msg.sender;
        _totalsupply = 5000;
        _balances[_creator] = _totalsupply;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return _totalsupply;
}

    function balanceOf(address _tokenOwner) external view virtual override returns (uint){
        return _balances[_tokenOwner];
    }
    function transfer(address _to, uint _token) external virtual override returns (bool){

        require(_token > 0 && _balances[msg.sender] >= _token);
        _balances[_to] += _token;

        _balances[msg.sender] -= _token;

        emit Transfer(msg.sender, _to, _token);

        return true;

    }

    function approve(address _spender, uint _tokens)  external virtual override returns (bool){

        _allowed[msg.sender][_spender] = _tokens;

        emit Approval(msg.sender, _spender, _tokens);

        return true;

    }
    function transferFrom(address from, address to, uint tokens) external virtual override returns (bool){
        require(tokens > 0 && _balances[from] >= tokens && _allowed[from][to] >= tokens);
        _balances[to] += tokens;
        _balances[from] -= tokens;

        _allowed[from][to] -= tokens;

        return true;

    }

    function allowance(address owner, address spender) external view virtual override returns (uint){
        return _allowed[owner][spender];
    }



}


contract ICO is myErc20Token{
    address public administrator;

     address payable public recipient;

     uint public tokenPrice = 10000000000000000;
     uint public targetPrice = 100000000000000000000;

     uint public receivedFund;

     uint public maxInvestment = 10000000000000000000;
     uint public minInvestment =  10000000000000000;

     enum Status {inactive, active, stopped, completed}

     Status public icoStatus;

     uint public icostart = block.timestamp;

     uint public icoEnd = block.timestamp + 432000;


     constructor(address payable _recipient) {
         administrator = msg.sender;
         recipient = _recipient;
     }

     modifier onlyOnwer{
         if(msg.sender == administrator){
             _;
         }

     }
     function setStopStatus() public onlyOnwer {
         icoStatus = Status.stopped;

     }
     function setActiveStatus() public onlyOnwer{
         icoStatus = Status.active;
     }

     function getIcoStatus() public view returns(Status){
         if(icoStatus == Status.stopped){
             return Status.stopped;
         }else if(block.timestamp >= icostart && block.timestamp <= icostart){
             return Status.active;
         }else if(block.timestamp < icostart){
             return Status.inactive;
         }else{
             return Status.completed;
         }
     }

     function investing() payable public returns(bool){

         icoStatus = getIcoStatus();
         require(icoStatus == Status.active, "Ico not active");
         require(targetPrice >= receivedFund + msg.value, "target acheived, inverstion not required");
         require(msg.value >= minInvestment && msg.value <= maxInvestment, "Investment not allowed in range");

         uint tokens = msg.value / tokenPrice;

        _balances[msg.sender] += tokens;

        _balances[_creator] -= tokens;

        recipient.transfer(msg.value);

        receivedFund += msg.value;

         return true;

     }

     function burn() public onlyOnwer{
         icoStatus = getIcoStatus();
         require(icoStatus == Status.completed, "Not completed");

         _balances[_creator] = 0;


     }

}
