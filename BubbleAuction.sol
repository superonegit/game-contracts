pragma solidity ^0.4.0;

import './Bank.sol';

contract BubbleAuction {

    Bank bank;
    uint256 multiplier;

    mapping(uint256 => address) bubbleOwners;

    function BubbleAuction(Bank _bank, uint256 _multiplier) {
        multiplier = _multiplier;
        bank = _bank;
    }

    function buyBubble(uint256 bubbleValue) public payable {
        address bubbleOwnerAddress = bubbleOwners[bubbleValue];

        require(bubbleOwnerAddress == 0); // nobody owns this value

        uint256 bubblePrice = bubbleValue * multiplier;

        require(bubblePrice >= bubbleValue);

        bank.transfer(msg.value);
    }
}
