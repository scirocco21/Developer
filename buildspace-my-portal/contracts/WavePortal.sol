// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);
    
    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }
    
    Wave[] waves;
    // create mapping between address and int (blocktime)
    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("Wassa Wassa Wassaaaap");
        // set initial seed using modulo and blockchain data
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        // require cool down period
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );
        // update latest blocktime at whic msg.sender called the contract
        lastWavedAt[msg.sender] = block.timestamp;
        // generate wave & emit event
        totalWaves += 1;
        waves.push(Wave(msg.sender, _message, block.timestamp));      
        console.log("%s has waved at ya at block #%s", msg.sender, block.number);
        emit NewWave(msg.sender, block.timestamp, _message);
        // update seed
        seed = (block.difficulty + block.timestamp + seed) % 100;
        // trigger payment for winner
        if (seed <= 25) {
            console.log("%s won!", msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        } 
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("Wohoo! We've collected %s waves!", totalWaves);
        return totalWaves;
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }
}