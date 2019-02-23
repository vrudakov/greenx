/* 
GreenX constructor +
transfer erc20 +
transferFrom erc20 +
approve erc20 +
allowance erc20 +
balanceOf erc20 +
() Payable function to distrubute token
getCurrentState - Get current state of sales campaign
issueTokenForPrivateInvestore - To distribure token to private investor 
issueTokenForPresale - To distribute token to normal investors joined presales
issueTokenForICO - To distribute token to normal investors ICO
trackdownInvestedEther - to track invested amount of Ether of investors not completed KYC 
issueToken - To distribute token to investor and transfer ETH to our wallet
addToWhitelist - to add new addresses to whitelist
addPriveateInvestor - to add new addresses to privatelist
removePrivateInvestor - to remove addresses from private list
startPrivateSale 
startPreSale
endPreSale
*/
pragma solidity >=0.4.22 <0.6.0;

import "./safeMath.sol";

contract accessManagment {
    
    address public owner;
    address public admin;
    address public portal;
    
    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier onlyAdmin() {
        require(msg.sender == admin || msg.sender == owner);
        _;
    }
    
    modifier onlyPortal() {
        require(msg.sender == portal || msg.sender == admin || msg.sender == owner);
        _;
    }
    
    modifier onlyInvestor() {
        
        _;
    }
    
    function setAdmin(address _admin) public onlyOwner{
        admin = _admin;
    }
    
    function setPortal(address _portal) public onlyAdmin {
        portal = _portal;
    }
    
}

contract ERC20 is accessManagment {
     using SafeMath for uint256;
     
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;
    uint256 public _totalSupply;
  
     
    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0));

        balances[msg.sender] = balances[msg.sender].sub(value);
        balances[to] = balances[to].add(value);
        emit Transfer(msg.sender, to, value);
        return true;
    }
    
    function transferFrom(address from, address to, uint amount ) public returns (bool) {
        require(to != address(0));
        require( balances[from] >= amount );
        require( allowed[from][msg.sender] >= amount );
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
        
        
    }
    
    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0));
        require(owner != address(0));
        allowed[owner][spender] = value;
        
        emit Approval(owner, spender, value);
        return true;
    }
    
    function allowance(address owner, address spender) public view returns (uint256) {
        return allowed[owner][spender];
    }
    
      function balanceOf(address owner) public view returns (uint256) {
        return balances[owner];
    }
    
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address from, address to, uint256 value);
}


contract GreenX is ERC20 {

    uint state;
    uint totalSupply = 500000000;
    uint decimal = 18;
    mapping (address => bool) public privateList;
    uint public amount;
    

    constructor () public {
       state = 1;
        amount = 0;
    }
    
    function () external payable {
        amount = amount + msg.value;
        address payable add = 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB;
        add.transfer(1 ether);
    }

    function addToPrivateList (address _investor) external onlyAdmin {
        require(_investor != address(0));
        privateList[_investor] = true;    
    }
    
    function getCurrentState() public view returns (string memory) { /* надо допилить */
        if (state == 0)
            return ("Sale closed");
        if (state == 1)
            return ("Sale open");
    }
    
}
