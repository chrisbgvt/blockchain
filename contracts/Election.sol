// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Election {
    struct Proposal {
        string name;
        uint256 voteCount;
    }

    address public chairperson;
    address public votingToken;
    mapping(address => bool) public voters;
    Proposal[] public proposals;
    uint256 public startDate;
    uint256 public endDate;

    event PlacedVote(string voted, address indexed voter);

    constructor(
        string[] memory proposalNames,
        uint256 _startDate,
        uint256 _endDate,
        address _chairperson,
        address _votingTokenAddress
    ) payable {
        chairperson = _chairperson;
        votingToken = _votingTokenAddress;
        startDate = _startDate;
        endDate = _endDate;

        for (uint256 i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
        }
    }

    modifier onlyFinished() {
        require(block.timestamp > endDate, "Election not finished");
        _;
    }

    function getProposalCount() public view returns (uint256) {
        return proposals.length;
    }

    function vote(uint256 proposalIndex, uint256 tokens) public {
        require(tokens > 0 && tokens < 2, "One token required");
        require(!voters[msg.sender], "Already voted");
        require(proposalIndex < proposals.length, "Invalid proposal index");
        require(msg.sender != chairperson, "Creator account cannot vote");

        uint256 tokenBalance = ERC20(votingToken).balanceOf(msg.sender);
        require(tokenBalance > 0, "Only addresses with VotingTokens can vote");
        require(tokenBalance >= tokens, "Insufficient tokens");

        require(address(this).balance >= tokens, "Insufficient balance of Election");
        (bool sent, ) = payable(address(this)).call{value: tokens}("");
        require(sent, "Failed to send Ether");

        proposals[proposalIndex].voteCount += tokens;
        voters[msg.sender] = true;

        emit PlacedVote(proposals[proposalIndex].name, msg.sender);
    }

    function winningProposal() internal view onlyFinished returns (uint256 winningIndex) {
        uint256 winningVoteCount = 0;

        for (uint256 i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningIndex = i;
            }
        }

        require(winningVoteCount > 0, "No votes are placed");
        return winningIndex;
    }

    function winnerName() public view onlyFinished returns (string memory winner) {
        winner = proposals[winningProposal()].name;
        return winner;
    }

    fallback() external payable {
        // Update contract balance
    }

    receive() external payable {
        // Do something with the received Ether
    }
}
