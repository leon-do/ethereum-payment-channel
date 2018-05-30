/*
_transaction = { 
    h: '0x67c29d874697e7065f58d18160e9d3e85cb4f621835b30ea86911052f64c31cb',
    v: 28,
    r: '0xd4e6a03ab13263a2813d4cf7d9a7429041fe938bb532109c0e7daf0f2df6bfc4',
    s: '0x774d2e70f819f7c3f3a778d12c01115dcaf238ce1116f5b51c7fb47a5cea6e8f',
    address: '0x14791697260E4c9A71f18484C9f997B308e59325',
    wei: 33000000000000000000,
    contractAddress: '0x28fb1aca4b64a6edff4d0287b81f0b2a2e75257b',
}
*/


const ethers = require('ethers')

_tx = signTx('0x28fb1aca4b64a6edff4d0287b81f0b2a2e75251b', 3000000000000000000)
console.log(_tx)
const validTx = verifyTx(_tx)
console.log(validTx)

function signTx(contractAddress, wei) {
    const privateKey = '0x0123456789012345678901234567890123456789012345678901234567890123'
    const signingKey = new ethers.SigningKey(privateKey)
    const signerAddress = signingKey.address

    // hash message
    const h = ethers.utils.solidityKeccak256(['address', 'int'], [contractAddress, wei.toString()])

    // sign and split message: https://github.com/ethers-io/ethers.js/issues/85
    const {r, s, recoveryParam} = signingKey.signDigest(h)
    const v = 27 + recoveryParam

    return { h, v, r, s, signerAddress, contractAddress, wei}
}

// returns true/false
function verifyTx(_tx) {
    try {
        const validSignature = ethers.SigningKey.recover(_tx.h, _tx.r, _tx.s, _tx.v - 27) === _tx.signerAddress
        const validAmount = ethers.utils.solidityKeccak256(['address', 'int'], [_tx.contractAddress, _tx.wei.toString()])
    
        if (validSignature && validAmount) {
            return true
        } else {
            return false
        }
    } catch (e) {
        console.error(e)
        return false
    }
}