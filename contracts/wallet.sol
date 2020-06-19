pragma solidity ^0.6.6;

interface IERC20 {
  function balanceOf(address) external view returns (uint);
  function transfer(address, uint) external returns (bool);
}

contract Wallet {

  function flush(address token) public {
    address payable treasury = 0x1d29756e8f7b091cE6c11a35980dE79c7eDa5D1f;
    if (token != address(0x0)) IERC20(token).transfer(treasury, IERC20(token).balanceOf(address(this)));
    if (address(this).balance > 0) treasury.transfer(address(this).balance);
  }

}