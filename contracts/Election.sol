//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

contract Election {
    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }

    struct Proposal {
        bytes32 name;
        uint voteCount;
    }

    address public chairperson;
    mapping(address => Voter) public voters;
    Proposal[] public proposals;

    //Suggestion Proposals which will be votted by Peoples
    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        for (uint256 i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name:proposalNames[i],
                voteCount:0
            }));
        }
    }

    //give permission to right person
    function giveRightToVote(address voter) external {
        require(msg.sender == chairperson,"No chairperson");
        require(!voters[voter].voted);
    }



}