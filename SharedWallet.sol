pragma solidity >=0.7.0 <=0.9.0;

import "./Allowance.sol";

contract SharedWallet is Allowance{

    using SafeMath for uint;

    event moneyWithdrawal(uint _amount, address indexed _who, uint _timestamp);
    event moneyDeposit(uint _amount, address indexed _who, uint _timestamp);

    receive() external payable{
        emit moneyDeposit(msg.value, msg.sender, block.timestamp);
    }

    fallback() external{

    }

    function withdraw(uint _amount) payable public ownerOrAllowed(_amount){
        require(_amount <= getBalance(), "Not enough funds.");
        payable(msg.sender).transfer(_amount);
        
        if(msg.sender != owner()){
            allowances[msg.sender] = allowances[msg.sender].sub(_amount);
        }

        emit moneyWithdrawal(_amount, msg.sender, block.timestamp);
    }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }

    function renounceOwnership() public override onlyOwner{
        revert("This functionality is disabled.");
    }
}
