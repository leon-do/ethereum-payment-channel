/*
_tx = { 
    h: '0xdc019231b53c4879ab424b7b797a907f0f9a17a2f30459bc3c36d79b53b5e8e8',
    v: 27,
    r: '0xe0d000429b116156c62c31d846b204d4c4807b7227d730964271248575ac2688',
    s: '0x128c960c2eb3e42e1c6d86ee40a19d44a39c78b4abba5987bffdd5909bd4bd5',
    signerAddress: '0x14791697260E4c9A71f18484C9f997B308e59325',
    contractAddress: '0x28fb1aca4b64a6edff4d0287b81f0b2a2e75251b',
    wei: 3000000000000000000 
}
*/
const ethers = require('ethers')

// contractAddress, amountInWei
_tx = signTx('0xb87213121fb89cbd8b877cb1bb3ff84dd2869cfa', 30*1000000000000000000)
console.log(_tx)
const validTx = verifyTx(_tx)
console.log(validTx)

function signTx(contractAddress, wei) {
    const privateKey = '0x0123456789012345678901234567890123456789012345678901234567890123'
    const signingKey = new ethers.SigningKey(privateKey)
    const signerAddress = signingKey.address

    const key = 'password'
    const hashedKey =  ethers.utils.keccak256(ethers.utils.toUtf8Bytes(key))

    // hash message
    const h = ethers.utils.solidityKeccak256(['address', 'int', 'bytes32'], [contractAddress, wei.toString(), hashedKey])

    // sign and split message: https://github.com/ethers-io/ethers.js/issues/85
    const {r, s, recoveryParam} = signingKey.signDigest(h)
    const v = 27 + recoveryParam

    return { h, v, r, s, signerAddress, contractAddress, wei, key, hashedKey}
}

// returns true/false
function verifyTx(_tx) {
    try {
        const signer = ethers.SigningKey.recover(_tx.h, _tx.r, _tx.s, _tx.v - 27)
        const proof = ethers.utils.solidityKeccak256(['address', 'int', 'bytes32'], [_tx.contractAddress, _tx.wei.toString(), _tx.hashedKey])

        // verify correct signer and proof    
        if (signer === _tx.signerAddress && proof === _tx.h) {
            return true
        } else {
            return false
        }
    } catch (e) {
        console.error(e)
        return false
    }
}