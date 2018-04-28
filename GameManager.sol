pragma solidity ^0.4.18;

import './utils/Ownable.sol';
import './Bank.sol';

contract GameManager is Ownable {

    struct Game {
        address winnerAddress;
        uint256 prize;
        bytes32 secretBid;
        string bid;
    }

    mapping(uint => Game) public games;
    Bank public bankAddress;

    function createGame(uint _gameId, bytes32 _secretBid) {
        games[_gameId].secretBid = _secretBid;
    }

    function setWinner(uint _gameId, address _winnerAddress, uint256 _weiAmount, string _bid) onlyOwner {
        bytes32 winHash = keccak256(_bid);

        bytes32 secretBid = games[_gameId].secretBid;

        if(winHash == secretBid) {

            games[_gameId].winnerAddress = _winnerAddress;
            games[_gameId].prize = _weiAmount;

            bankAddress.transferPrize(_winnerAddress, _weiAmount);
        }
    }

    function () public payable {
        revert();
    }

    function selfdestruct() {
        revert();
    }
}
