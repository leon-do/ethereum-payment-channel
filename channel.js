const ethers = require('ethers')

const signedMessage = signMessage('0x28fb1aca4b64a6edff4d0287b81f0b2a2e75257b' ,33)
console.log(signedMessage)

function signMessage(_contractAddress, _amount) {
    const privateKey = '0x0123456789012345678901234567890123456789012345678901234567890123'
    const signingKey = new ethers.SigningKey(privateKey);
    const address = signingKey.address

    // to wei
    const amount = _amount * 1000000000000000000

    // hash message
    const h = ethers.utils.solidityKeccak256(['address', 'int'], [_contractAddress, amount.toString()]);

    // sign and split message: https://github.com/ethers-io/ethers.js/issues/85
    const {r, s, recoveryParam} = signingKey.signDigest(h);
    const v = 27 + recoveryParam

    return { h, v, r, s, address, amount}
}
