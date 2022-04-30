pragma solidity >=0.7.0 <=0.9.0;
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/access/Ownable.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/utils/math/SafeMath.sol";


contract Allowance is Ownable{

    event AllowanceChanged(address indexed _forWho, address indexed _fromWhom, uint _oldAmount, uint _newAmount);

    mapping (address => uint) public allowances;
    
    using SafeMath for uint;

    modifier ownerOrAllowed(uint _amount){
        require(msg.sender == owner() || _amount <= allowances[msg.sender]);
        _;
    }

    function addAllowance(address _who, uint _amount) public onlyOwner{
        emit AllowanceChanged(_who, msg.sender, allowances[_who], allowances[_who].add(_amount));
        allowances[_who] = allowances[_who].add( _amount);
    }

    function reduceAllowance(address _who, uint _amount) public onlyOwner{
        require(allowances[_who] <= _amount);
        emit AllowanceChanged(_who, msg.sender, allowances[_who], allowances[_who].sub(_amount));
        allowances[_who] = allowances[_who].sub(_amount);
    }
}
