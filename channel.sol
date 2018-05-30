// https://medium.com/@matthewdif/ethereum-payment-channel-in-50-lines-of-code-a94fad2704bc

pragma solidity ^0.4.0;

contract Channel {

    address public channelSender;
    address public channelRecipient;
    uint public startDate;
    uint public channelTimeout;
    mapping (bytes32 => address) signatures;

    function Channel(address to, uint timeout) payable {
        // 0x14791697260E4c9A71f18484C9f997B308e59325
        channelRecipient = to;
        channelSender = msg.sender;
        startDate = now;
        // in seconds
        channelTimeout = timeout;
    }

    function CloseChannel(bytes32 _h, uint8 _v, bytes32 _r, bytes32 _s, uint _value){

        address signer;
        bytes32 proof;

        // get signer from signature
        signer = ecrecover(_h, _v, _r, _s);

        // signature is invalid, throw
        if (signer != channelSender && signer != channelRecipient) throw;

        // proof = I signed this contract with a value
        proof = sha3(this, _value);

        // signature is valid but doesn't match the data provided
        if (proof != _h) throw;

        // send to recipient
        channelRecipient.send(_value);
        
        // close channel
        selfdestruct(channelSender);
    }

    function ChannelTimeout(){
        if (startDate + channelTimeout > now)
            throw;

        selfdestruct(channelSender);
    }

}

