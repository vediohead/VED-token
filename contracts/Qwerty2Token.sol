pragma solidity ^0.4.23;

/**
 * 'Qwerty2' token contract
 * by dev team
 * adapted from OpenZeppelin @ 1.9.0
 */


/**
 * -------- Math start --------
 * @title Math
 * @dev Assorted math operations
 */
library Math {
  function max64(uint64 a, uint64 b) internal pure returns (uint64) {
    return a >= b ? a : b;
  }

  function min64(uint64 a, uint64 b) internal pure returns (uint64) {
    return a < b ? a : b;
  }

  function max256(uint256 a, uint256 b) internal pure returns (uint256) {
    return a >= b ? a : b;
  }

  function min256(uint256 a, uint256 b) internal pure returns (uint256) {
    return a < b ? a : b;
  }
}
/**
 * -------- Math end --------
 */


/**
 * -------- SafeMath start --------
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
   * @dev Multiplies two numbers, throws on overflow.
   */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    require(c / a == b);
    return c;
  }

  /**
   * @dev Integer division of two numbers, truncating the quotient.
   */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // require(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // require(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
   */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    return a - b;
  }

  /**
   * @dev Adds two numbers, throws on overflow.
   */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    require(c >= a);
    return c;
  }
}
/**
 * -------- SafeMath end --------
 */


/**
 * -------- ERC20Basic start --------
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev See https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);


  event Transfer(address indexed from, address indexed to, uint256 value);
}
/**
 * -------- ERC20Basic end --------
 */


/**
 * -------- ERC20 start --------
 * @title ERC20 interface
 * @dev See https://github.com/ethereum/EIPs/issues/20
 * @dev See also https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);


  event Approval(address indexed owner, address indexed spender, uint256 value);
}
/**
 * -------- ERC20 end --------
 */


/**
 * -------- BasicToken start --------
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  uint256 _totalSupply;

  /**
   * @dev total number of tokens in existence
   */
  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }

  /**
   * @dev transfer token for a specified address
   * @param _to The address to transfer to.
   * @param _value The amount to be transferred.
   */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
   * @dev Gets the balance of the specified address.
   * @param _owner The address to query the the balance of.
   * @return An uint256 representing the amount owned by the passed address.
   */
  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }
}
/**
 * -------- BasicToken end --------
 */


/**
 * -------- StandardToken start --------
 * @title Standard ERC20 token
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
    uint256 oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }
}
/**
 * -------- StandardToken end --------
 */


/**
 * -------- Ownable start --------
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }
}
/**
 * -------- Ownable end --------
 */


/**
 * @notice Borrowed from `MiniMeToken`, this allows the execution of approval and function together in one call
 */
contract ApproveAndCallFallBack {
  function receiveApproval(address from, uint256 tokens, address tokenAddress, bytes _data) public;
}


/**
 * Qwerty2 Token Contract start
 */
contract Qwerty2Token is StandardToken, Ownable {
  using SafeMath for uint256;

  string public constant name = "Qwerty2 Token";
  string public constant symbol = "QQR";
  uint8 public constant decimals = 18;
  string public constant version = "0.1";
  uint256 public _totalSupply;


  /**
   * Constructor
   */
  constructor() public {
    _totalSupply = 500000000000000000000000000;

    balances[0x5765412d438D171728237671e5e5cf2e31cD0066] = _totalSupply;

    emit Transfer(address(0), 0x5765412d438D171728237671e5e5cf2e31cD0066, _totalSupply);
  }


  /**
   * @notice Total supply
   */
  function totalSupply() public constant returns (uint256) {
    return _totalSupply - balances[address(0)];
  }


  function transfer(address to, uint256 tokens) public returns (bool success) {
    return super.transfer(to, tokens);
  }


  function approve(address _spender, uint256 tokens) public returns (bool success) {
    return super.approve(_spender, tokens);
  }


  /**
   * @notice Token owner can approve for spender to transferFrom(...) tokens from the token owner's account. The spender contract function receiveApproval(...) is then executed
   */
  function approveAndCall(address _spender, uint256 tokens, bytes _data) public returns (bool success) {
    allowed[msg.sender][_spender] = tokens;
    emit Approval(msg.sender, _spender, tokens);
    ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, tokens, this, _data);
    return true;
  }


  /**
   * Owner can transfer out any accidentally sent ERC20 tokens
   */
  function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
    return ERC20(tokenAddress).transfer(owner, tokens);
  }


  /**
   * ETH transaction start
   */
  function () public payable {
    revert();
  }
  /**
   * ETH transaction end
   */
}
/**
 * Qwerty2 Token Contract end
 */
