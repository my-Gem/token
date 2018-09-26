pragma solidity ^0.4.24;  //编译器版本要求

contract ERC20Interface {

    string public constant name = "传奇币";//代币名称
    string public constant symbol = "CQB"; //代币符号
    uint8 public constant decimals = 18;

    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract BSToken is ERC20Interface{

  string public name;//代币名称
  string public symbol;//代币符号
  uint8 public decimals; //代币小数点位数，代币的最小单位， 如3表示我们可以拥有 0.001单位个代币
  uint256 public totalSupply;//发行代币总量


  mapping (address => uint256) public balanceOf;// 用mapping保存每个地址对应的余额
  // allowanceOf保存每个地址（第一个address） 授权给其他地址(第二个address)的额度（uint256）也就是存取被授权人的额度
  mapping (address => mapping (address => uint256)) public allowanceOf;

   constructor()public {
      name = "传奇币";
      symbol = "CQB";
      decimals = 0;
      totalSupply = 100000000;//默认一亿
      balanceOf[msg.sender] = totalSupply;
   }

   /**
    *代币交易转移的内部实现
    */
    function _transfer(address _from, address _to, uint _value) internal {
       require(_to != 0x0);  //确保目标地址不为0x0，因为0x0地址代表销毁
       require(balanceOf[_from] >= _value); // 检查发送者余额
       require(balanceOf[_to] + _value > balanceOf[_to]);  // 溢出检查
       uint previousBalances = balanceOf[_from] + balanceOf[_to];// 以下用来检查交易
       balanceOf[_from] -= _value;
       balanceOf[_to] += _value;
       emit Transfer(_from, _to, _value);
       assert(balanceOf[_from] + balanceOf[_to] == previousBalances); // 用assert来检查代码逻辑。
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
       _transfer(msg.sender, _to, _value);
       return true;
   }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
       require(allowanceOf[_from][msg.sender] >= _value);
       allowanceOf[_from][msg.sender] -= _value;
       _transfer(_from, _to, _value);
       return true;
   }

    function approve(address _spender, uint256 _value) public returns (bool success) {
       allowanceOf[msg.sender][_spender] = _value;
       emit Approval(msg.sender, _spender, _value);
       return true;
   }

   function allowance(address _owner, address _spender) view public returns (uint remaining){
     return allowanceOf[_owner][_spender];
   }

    //发行代币总量
  function totalSupply() public constant returns (uint totalsupply){
      return totalSupply;
  }

  // 查看对应账号的代币余额
  function balanceOf(address tokenOwner) public constant returns(uint balance){
      return balanceOf[tokenOwner];
  }

}
