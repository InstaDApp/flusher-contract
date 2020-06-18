pragma solidity ^0.6.6;

import {IERC20, Wallet} from "./wallet.sol";

contract Deployer {

   /**
     * @dev Deploy Create2 + Minimal Proxy
     * @param _salt salt.
     * @param _logic minimal proxy address.
    */
  function deployMinimalWithCreate2(
        uint256 _salt,
        address _logic
    ) public returns (address proxy) {
        bytes32 salt = _getSalt(_salt, msg.sender);
        bytes20 targetBytes = bytes20(_logic);
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            let clone := mload(0x40)
            mstore(
                clone,
                0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
            )
            mstore(add(clone, 0x14), targetBytes)
            mstore(
                add(clone, 0x28),
                0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
            )
            proxy := create2(0, clone, 0x37, salt)
        }
  }

  /**
     * @dev Compute Create2 + Minimal Proxy address
     * @param _salt salt.
     * @param _sender sender address.
     * @param _logic minimal proxy address.
    */
  function getDeploymentAddress(uint256 _salt, address _sender, address _logic) public view returns (address) {
    bytes32 codeHash = keccak256(getMinimalProxyCreationCode(target));
    bytes32 salt = _getSalt(_salt, _sender);
    bytes32 rawAddress = keccak256(
      abi.encodePacked(
        bytes1(0xff),
        address(this),
        salt,
        codeHash
      ));
      return address(bytes20(rawAddress << 96));
  }

  function _getSalt(uint256 _salt, address _sender) internal pure returns (bytes32) {
    return keccak256(abi.encodePacked(_salt, _sender));
  }

  function getMinimalProxyCreationCode(address target) internal pure returns (bytes memory) {
    bytes20 a = bytes20(0x3D602d80600A3D3981F3363d3d373d3D3D363d73);
    bytes20 b = bytes20(target);
    bytes15 c = bytes15(0x5af43d82803e903d91602b57fd5bf3);
    return abi.encodePacked(a, b, c);
  }
}