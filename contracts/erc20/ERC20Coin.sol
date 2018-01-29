pragma solidity ^0.4.18;

import "../ownership/Owned.sol";
import "../math/SafeMath.sol";
import "./ERC20Interface.sol";

// ----------------------------------------------------------------------------
//
// ERC Coin Standard #20
//
// ----------------------------------------------------------------------------

contract ERC20Coin is ERC20Interface, Owned {
  
  using SafeMath for uint;

  uint public coinsIssuedTotal = 0;
  mapping(address => uint) public balances;
  mapping(address => mapping (address => uint)) public allowed;

  // Functions ------------------------

  /* Total coin supply */

  function totalSupply() public constant returns (uint) {
    return coinsIssuedTotal;
  }

  /* Get the account balance for an address */

  function balanceOf(address _owner) public constant returns (uint balance) {
    return balances[_owner];
  }

  /* Transfer the balance from owner's account to another account */

  function transfer(address _to, uint _amount) public returns (bool success) {
    // amount sent cannot exceed balance
    require(balances[msg.sender] >= _amount);

    // update balances
    balances[msg.sender] = balances[msg.sender].sub(_amount);
    balances[_to] = balances[_to].add(_amount);

    // log event
    Transfer(msg.sender, _to, _amount);
    return true;
  }

  /* Allow _spender to withdraw from your account up to _amount */

  function approve(address _spender, uint _amount) public returns (bool success) {
    // approval amount cannot exceed the balance
    require (balances[msg.sender] >= _amount);
      
    // update allowed amount
    allowed[msg.sender][_spender] = _amount;
    
    // log event
    Approval(msg.sender, _spender, _amount);
    return true;
  }

  /* Spender of coins transfers coins from the owner's balance */
  /* Must be pre-approved by owner */

  function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
    // balance checks
    require(balances[_from] >= _amount);
    require(allowed[_from][msg.sender] >= _amount);

    // update balances and allowed amount
    balances[_from] = balances[_from].sub(_amount);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
    balances[_to] = balances[_to].add(_amount);

    // log event
    Transfer(_from, _to, _amount);
    return true;
  }

  /* Returns the amount of coins approved by the owner */
  /* that can be transferred by spender */

  function allowance(address _owner, address _spender) public constant returns (uint remaining) {
    return allowed[_owner][_spender];
  }

}