// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title SimpleVoting - beginner-friendly voting contract (no deploy inputs)
/// @author - you
/// @notice Owner deploys the contract (no constructor params). Owner can add candidates and start/stop voting.
/// @dev Simple protections: one vote per address, voting must be active to cast votes.
contract SimpleVoting {
    address public owner;
    bool public votingActive;

    struct Candidate {
        string name;
        uint256 voteCount;
    }

    Candidate[] private candidates;
    mapping(address => bool) public hasVoted;

    // Events
    event CandidateAdded(uint256 indexed candidateId, string name);
    event VotingStarted();
    event VotingEnded();
    event Voted(address indexed voter, uint256 indexed candidateId);

    // Modifier to restrict to owner
    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    // Modifier to require voting is active
    modifier whenVotingActive() {
        require(votingActive, "voting is not active");
        _;
    }

    // Constructor: no input fields required
    constructor() {
        owner = msg.sender;
        votingActive = false;
    }

    /// @notice Owner can add a candidate (only before/during voting as you prefer)
    /// @param _name Candidate name
    function addCandidate(string calldata _name) external onlyOwner {
        require(bytes(_name).length > 0, "name required");
        candidates.push(Candidate({name: _name, voteCount: 0}));
        emit CandidateAdded(candidates.length - 1, _name);
    }

    /// @notice Start the voting (owner only)
    function startVoting() external onlyOwner {
        require(!votingActive, "voting already active");
        require(candidates.length > 0, "no candidates");
        votingActive = true;
        emit VotingStarted();
    }

    /// @notice End the voting (owner only)
    function endVoting() external onlyOwner {
        require(votingActive, "voting not active");
        votingActive = false;
        emit VotingEnded();
    }

    /// @notice Cast a vote for candidateId (index in candidates array)
    /// @param candidateId index of candidate in the candidates array (0-based)
    function vote(uint256 candidateId) external whenVotingActive {
        require(!hasVoted[msg.sender], "already voted");
        require(candidateId < candidates.length, "invalid candidate");
        hasVoted[msg.sender] = true;
        candidates[candidateId].voteCount += 1;
        emit Voted(msg.sender, candidateId);
    }

    /// @notice Get number of candidates
    function getCandidateCount() external view returns (uint256) {
        return candidates.length;
    }

    /// @notice Get candidate details by index
    /// @param candidateId index of candidate (0-based)
    function getCandidate(uint256 candidateId)
        external
        view
        returns (string memory name, uint256 votes)
    {
        require(candidateId < candidates.length, "invalid candidate");
        Candidate storage c = candidates[candidateId];
        return (c.name, c.voteCount);
    }

    /// @notice Owner can reset votes (useful for repeated polls). This does not remove candidates.
    function resetVotes() external onlyOwner {
        for (uint256 i = 0; i < candidates.length; i++) {
            candidates[i].voteCount = 0;
        }
        // reset voter mapping is intentionally left out for gas reasons.
        // To support fully resetting voters you'd need to manage a voter list.
    }

    /// @notice Convenience: add multiple candidates (owner only)
    /// @param _names array of names to add
    function addCandidates(string[] calldata _names) external onlyOwner {
        for (uint256 i = 0; i < _names.length; i++) {
            require(bytes(_names[i]).length > 0, "empty name");
            candidates.push(Candidate({name: _names[i], voteCount: 0}));
            emit CandidateAdded(candidates.length - 1, _names[i]);
        }
    }
}
