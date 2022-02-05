//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
contract MyVote {
    bool public voteRunning = true;
    int public votesNeeded;
    bool public votePassed = false;
    bytes32 private merkleRoot;
    uint public agreedVoters = 0;
    uint public disagreeVoters = 0;
    event VoteFinished(
        bool result
    );
    constructor(int _votesNeeded, bytes32 merkleRoot_) {
        votesNeeded = _votesNeeded;
        merkleRoot = merkleRoot_;
    }
    function getVoteStatus() external view returns (string memory) {
        if (voteRunning) {
            return "RUNNING";
        } else if (votePassed) {
            return "PASSED";
        } else {
            return "FAILED";
        }
    }
    function vote(bool isFor, bytes32[] calldata proof) public {
        require(voteRunning, "vote is finished");
        bytes32 node = keccak256(abi.encodePacked(msg.sender));
        require(!MerkleProof.verify(proof, merkleRoot, node),"you are in already voted");
        if (isFor) {
            agreedVoters += 1;
        } else {
            disagreeVoters += 1; 
        }
    }
}