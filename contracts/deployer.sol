pragma solidity ^0.6.6;

interface IERC20 {
  function balanceOf(address) external view returns (uint);
  function transfer(address, uint) external returns (bool);
}

contract CandraWallet {

  function flush(address token) public {
    address payable treasury = 0x1d29756e8f7b091cE6c11a35980dE79c7eDa5D1f;
    if (token != address(0x0)) IERC20(token).transfer(treasury, IERC20(token).balanceOf(address(this)));
    if (address(this).balance > 0) treasury.transfer(address(this).balance);
  }

}

contract CandraDeployer {

  function calculateAddress(uint256 seed) public view returns (address) {
    bytes32 codeHash = keccak256(type(CandraWallet).creationCode);
    bytes32 salt = bytes32(seed);
    bytes32 rawAddress = keccak256(
      abi.encodePacked(
        bytes1(0xff),
        address(this),
        salt,
        codeHash
      )
    );
    return address(bytes20(rawAddress << 96));
  }

  function deploy(uint256 seed, address token) public returns (address wallet) {
    bytes memory code = type(CandraWallet).creationCode;
    bytes32 salt = bytes32(seed);
    assembly {
        wallet := create2(0, add(code, 0x20), mload(code), salt)
        if iszero(extcodesize(wallet)) {revert(0, 0)}
    }
    CandraWallet(wallet).flush(token);
  }

}