pragma solidity ^0.4.0;

import './usingOraclize.sol';

contract RNG is usingOraclize {
    event RandomNumberGenerated(bytes);

    function() payable {}

    function __callback(bytes32 _queryId, string _result, bytes _proof) {

        require(msg.sender == oraclize_cbAddress());
        if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {

        } else {
            RandomNumberGenerated(bytes(_result));
        }
    }

    function generateRandomNumber(uint bytesCount) {
        oraclize_setProof(proofType_Ledger);

        uint delay = 0;
        uint callbackGas = 300000;

        bytes32 queryId = oraclize_newRandomDSQuery(delay, bytesCount, callbackGas);
    }
}
