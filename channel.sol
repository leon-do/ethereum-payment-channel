pragma solidity ^0.4.0;

contract Channel {

    address public address1;
    address public address2;
    uint public startDate;
    uint public channelTimeout;
    
    constructor(address _toAddress, uint _timeout) payable public {
        address1 = msg.sender;
        address2 = _toAddress;
        startDate = now;
        // in seconds
        channelTimeout = _timeout;
    }

    function CloseChannel(bytes32 _h, uint8 _v, bytes32 _r, bytes32 _s, uint _wei) public {
        address signer;
        bytes32 proof;
        
        // only address2 can close channel
        // if (msg.sender != address2) revert();
        
        // get signer from signature
        signer = ecrecover(_h, _v, _r, _s);

        // signature is invalid, throw
        if (signer != address2) revert();

        // proof = I signed this contract with a value
        proof = keccak256(this, _wei);

        // signature is valid but doesn't match the data provided
        if (proof != _h) revert();

        // send to recipient
        address2.transfer(_wei);
        
        // close channel
        selfdestruct(address1);
    }

    function ChannelTimeout() public {
        if (startDate + channelTimeout > now)
            revert();

        selfdestruct(address1);
    }

}
