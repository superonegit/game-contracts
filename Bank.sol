pragma solidity ^0.4.0;

import './utils/Ownable.sol';
import './utils/SafeMath.sol';

contract Bank is Ownable {

    using SafeMath for uint256;

    uint256 public totalBankBalance;
    address public gameManager;
    address public auctionManager;

    mapping (address => uint256) public playerBalance;

    modifier onlyGameManager() {
        require(msg.sender == gameManager);
        _;
    }

    function deposit() public payable {
        require(msg.value != 0);
        require(msg.sender != 0);

        uint256 balance = playerBalance[msg.sender];
        playerBalance[msg.sender] = balance.add(msg.value);

        totalBankBalance = totalBankBalance.add(msg.value);
    }

    function doHash(uint256 weiAmount) public returns(bytes32) {
        bytes32 hash = keccak256(
            keccak256('uint256 wei'),
            keccak256(weiAmount)
        );

        return hash;
    }

    // user's signed message sent by bank owner to withdraw
    // pk - user's public key
    // weiAmount - amount of wei
    // bankBalance - backend wei balance
    function withdraw(uint256 weiAmount, uint256 bankBalance,
        uint8 v, bytes32 r, bytes32 s) onlyOwner public {

        bytes32 hash = doHash(weiAmount);
        address recoveredAddress = ecrecover(hash, v, r, s);

        uint256 balance = playerBalance[recoveredAddress];

        require(balance > 0);
        require(bankBalance >= weiAmount);

        playerBalance[recoveredAddress] = playerBalance[recoveredAddress].sub(weiAmount);
        recoveredAddress.transfer(weiAmount);
    }

    function transferPrize(address winner, uint256 weiAmount) public onlyGameManager {
        require(totalBankBalance >= weiAmount);
        totalBankBalance = totalBankBalance.sub(weiAmount);
        winner.transfer(weiAmount);
    }

    function grantBonusForBubble(address bubbleOwner) public payable onlyOwner {
        playerBalance[bubbleOwner] += msg.value;
    }

    function setGameManager(address manager) public onlyOwner {
        gameManager = manager;
    }

    function setAuctionManager(address manager) public onlyOwner {
        auctionManager = manager;
    }

    function() public payable {
        deposit();
    }

    function selfdestruct() public {
        revert();
    }
}
