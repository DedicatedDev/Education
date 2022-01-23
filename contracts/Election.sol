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
    address[] public votorsAddressList;
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
        require(!voters[voter].voted, "Already voted person");
        require(voters[voter].weight == 0, "Have weight already");
        voters[voter].weight = 1;
        votorsAddressList.push(voter);
    }

    //delegate vote to trusted person
    function delegate(address to) external {
        require(to!= address(0),"Untrusted user");
        require(msg.sender != address(0),"Untrusted sender");
        Voter storage sender = voters[msg.sender];
        require(!sender.voted,"Already votted user!");
        require(msg.sender == to,"Can't delegate to yourself");
        
        //Need to find final delegate in delegate chain. 
        while(voters[to].delegate != address(0)){
            to = voters[to].delegate;
            require(to != msg.sender, "Circle loop in delegate");
        }
        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];
        if (delegate_.voted) {
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            delegate_.weight += sender.weight;
        }
    }

    //vote
    function vote(uint proposal) external {
        require(proposal < proposals.length, "Did not select valid proposal");
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted");
        sender.voted = true;
        sender.vote = proposal;
        proposals[proposal].voteCount += sender.weight;
    }

    //finish vote
    function winningProposal() public view returns (uint winningProposal_) {
        uint winningVoteCount = 0;
        for (uint256 p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    function winnerInfo() external view returns (bytes32 winnerName_, uint voteCount_) {
        uint256 winnderIndex = winningProposal();
        winnerName_ = proposals[winnderIndex].name;
        voteCount_ = proposals[winnderIndex].voteCount;
    }
}