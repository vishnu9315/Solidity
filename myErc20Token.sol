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
    string public symbol = "VS";
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
