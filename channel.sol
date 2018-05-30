pragma solidity ^0.4.0;

contract Channel {

    address public channelSender;
    address public channelRecipient;
    uint public startDate;
    uint public channelTimeout;

<<<<<<< HEAD
    function Channel(address _to, uint timeout) payable {
        // 0x14791697260E4c9A71f18484C9f997B308e59325
=======
    constructor(address _to, uint _timeout) payable public {
>>>>>>> 1c76f5ddc91f2663279745746086dbfea76193cc
        channelRecipient = _to;
        channelSender = msg.sender;
        startDate = now;
        // in seconds
        channelTimeout = _timeout;
    }

    function CloseChannel(bytes32 _h, uint8 _v, bytes32 _r, bytes32 _s, uint _value) public {

        address signer;
        bytes32 proof;

        // get signer from signature
        signer = ecrecover(_h, _v, _r, _s);

        // signature is invalid, throw
<<<<<<< HEAD
        if (signer != channelSender) throw;

        // proof = I signed this contract with a value
        proof = sha3(this, _value);
=======
        if (signer != channelSender) revert();
        
        // proof = I signed this contract with a _value
        proof = keccak256(this, _value);
>>>>>>> 1c76f5ddc91f2663279745746086dbfea76193cc

        // signature is valid but doesn't match the data provided
        if (proof != _h) revert();

        // send to recipient
        channelRecipient.transfer(_value);
        
        // close channel
        selfdestruct(channelSender);
    }

    function ChannelTimeout() public {
        if (startDate + channelTimeout > now)
            revert();

        selfdestruct(channelSender);
    }

}
