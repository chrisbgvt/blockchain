// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Election.sol";

contract ElectionFactory is ERC20 {
    uint public electionId = 0;
    mapping(uint => address) public elections;
    address public votingAddress = address(this);

    event CreatedToken(uint256 electionId, address indexed votingAddress);

    constructor() ERC20("VotingToken", "VOTE") {
        _mint(msg.sender, 1000 * (10 ** uint256(decimals())));
        // For voting accounts to have balance send token with transfer() method
    }

    function createElection(
        string[] memory proposalNames,
        uint256 _startDate,
        uint256 _endDate
    ) public payable {
        Election election = new Election(
            proposalNames,
            _startDate,
            _endDate,
            msg.sender,
            votingAddress
        );
        elections[electionId] = address(election);
        electionId++;

        emit CreatedToken(electionId, votingAddress);

        require(msg.value > 0, "No tokens provided");
        (bool sent, ) = payable(address(election)).call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}
