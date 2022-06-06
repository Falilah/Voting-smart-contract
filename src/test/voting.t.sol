// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "lib/forge-std/src/Test.sol";
import "../voting.sol";



contract TestVoting is Test{
    Voting voting;
    function setUp() public{
        voting = new Voting();

    }

    function testcreatePoll() public {
        voting.createPoll("ClassGov", 200000000000000000, 5);
        require(voting.votingPoll["classGov"].chairman == msg.sender);
        
    }

}