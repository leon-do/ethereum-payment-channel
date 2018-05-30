pragma solidity ^0.4.0;

contract Channel {

    address public channelSender;
    address public channelRecipient;
    uint public startDate;
    uint public channelTimeout;
    mapping (bytes32 => address) signatures;

    constructor(address _to, uint _timeout) payable public {
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
        if (signer != channelSender) revert();
        
        // proof = I signed this contract with a _value
        proof = keccak256(this, _value);

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
