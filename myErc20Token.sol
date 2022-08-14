// SPDX-License-Identifier: aIT
pragma solidity >=0.5.0 <0.9.0;

interface ERC20 {
//totalsupply- it returns the initial quantity of tokens
function totalSupply() external view returns (uint256);
//balanceOf - it returns the number of token hold by any particular address
function balanceOf(address tokenOwner) external view returns (uint);
//allowance - it is to know the number of remaining approved tokens.
function allowance(address tokenOwner, address spender) external view returns (uint);
//transfer - it is to transfer the token from one account to other
function transfer(address to, uint tokens) external returns (bool);
//approve - owner approves a spender to use its own token
function approve(address spender, uint tokens)  external returns (bool);
//transferFrom - once approved, it is used to transfer all or partial approved token
function transferFrom(address from, address to, uint tokens) external returns (bool);
//approval event- it is used inside approved function to log the activity of approved function
event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
//transfer event - it is used to log the transfer function activity like from account to account
//and how mych token was transfered
event Transfer(address indexed from, address indexed to, uint tokens);
}

contract myErc20Token is ERC20 {
    mapping(address => uint) public _balances;

    mapping(address => mapping(address => uint)) _allowed;

    //name, tokenSymbol, decimal
    string public name = "MemeToken";
    string public symbol = "MMT";
    uint public decimal = 0;

    //initial supply
    uint public _totalsupply;

    //creator address
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
