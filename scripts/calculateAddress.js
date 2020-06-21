var Web3Utils = require('web3-utils');

/*
* @param saltId => unique id
* @param saltAddress => msg.sender of the deployment function.
* @param deployerAddress => factory contract address
* @param minimalProxyAddress => minimal proxy address
*/
function calculateAddress(saltId, saltAddress, deployerAddress, minimalProxyAddress) {
    if(!Web3Utils.isAddress(saltAddress)) return false
    var saltCode = Web3Utils.soliditySha3(saltId, saltAddress.slice(2))
    var bytecode = Web3Utils.keccak256(getByteCode(minimalProxyAddress))
    return Web3Utils.toChecksumAddress(`0x${Web3Utils.sha3(`0x${[
        'ff',
        deployerAddress,
        saltCode,
        bytecode
    ].map(x => x.replace(/0x/, '')).join('')}`).slice(-40)}`);
}

function getByteCode(target) {
    var _address = target.startsWith('0x') ? target.slice(2) : _address = target
    var bytecode = "0x3d602d80600a3d3981f3363d3d373d3d3d363d73"
    bytecode += _address.toLowerCase()
    bytecode += "5af43d82803e903d91602b57fd5bf3"
    return bytecode
}

console.log(
    calculateAddress(
        "100",
        "0xb46693c062b49689cc4f624aab24a7ea90275890",
        "0x881F879dD2934859B09675a30C2c16b111C8Fe1B",
        "0xc0f4a736714C68971eFEB3E3FddD2e03197839c1"
    )
)
