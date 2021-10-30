// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    address payable[] wavers;

    constructor() {
        console.log("Wassa Wassa Wassaaaap");
    }

    function wave() public {
        totalWaves += 1;
        wavers.push(payable(msg.sender));
      
        console.log("%s has waved at ya at block #%s", msg.sender, block.number);
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("Wohoo! We've collected %s waves from %s waver(s)!!", totalWaves, wavers.length);
        return totalWaves;
    }

}