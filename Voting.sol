// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract Voting is ERC20,Ownable,ReentrancyGuard {

    constructor() ERC20("Voting", "VT") {}

    function mint(address account, uint256 amount) public onlyOwner {  //creating tokens
        _mint(account, amount);
        votingTokens[account] += amount;
    }

    function getTokenBalance(address account) public view returns (uint256) {
    return balanceOf(account);
    }

    function transferToContract(uint256 amount) public { //send tokens to the contract 
    require(balanceOf(msg.sender) >= amount, "Not enough tokens");

    // Transfer tokens to contract
    transfer(address(this), amount);
    }


--------------------------------------------------------------------------

final code 2023/09/16

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract Voting is ERC20,Ownable,ReentrancyGuard {

    constructor() ERC20("Voting", "VT") {}

    function mint(address account, uint256 amount) public onlyOwner {  //creating tokens
        _mint(account, amount);
        votingTokens[account] += amount;
    }

    function getTokenBalance(address account) public view returns (uint256) {
    return balanceOf(account);
    }

    function transferToContract(uint256 amount) public { //send tokens to the contract 
    require(balanceOf(msg.sender) >= amount, "Not enough tokens");

    // Transfer tokens to contract
    transfer(address(this), amount);
    }



address[] public candidateList;
address[] public voterslist;

mapping(address => uint256) public votingTokens;
mapping (address => uint8) public votesRecieved;
mapping(address => bool) public hasVoted;
mapping(address => bool) public hasParticipated;


address public winner;
uint public winnerVotes;

enum VotingStatus { NotStarted, Running, Completed }
VotingStatus public status;


modifier onlyRunning() {
    require(status == VotingStatus.Running, "Election is not active");
    _;
}

function setStatus() public onlyOwner {
    if (status != VotingStatus.Completed && status != VotingStatus.Running){
        status = VotingStatus.Running;
    }
    else {
        status = VotingStatus.Completed;
    }
}

function resetVoting() external onlyOwner {
    require(status == VotingStatus.Completed, "Voting must be completed before it can be reset.");
    require(candidateList.length > 0, "There are no candidates registered to reset.");

    // Reset candidate-related state variables
    for (uint i = 0; i < candidateList.length; i++) {
        delete votesRecieved[candidateList[i]];
    }
    delete candidateList;
    delete voterslist;
    delete winner;
    winnerVotes = 0;
    status = VotingStatus.NotStarted;

    // Reset voter-related mappings and votingTokens only for those who have voted before
    for (uint i = 0; i < voterslist.length; i++) {
        address voter = voterslist[i];
        if (hasVoted[voter]) {
            delete hasVoted[voter];
            delete hasParticipated[voter];
            votingTokens[voter] += 1; // Reset the votingTokens balance to the original value
        }
    }
}


function registerCandidate(address _candidate) public onlyOwner {
    require(status == VotingStatus.NotStarted, "voting process going on");
    require(!validateCandidate(_candidate), "Candidate is already registered");
    candidateList.push(_candidate);
}

function vote(address _candidate) public onlyRunning {
    require(validateCandidate(_candidate), " Candidate Not valid");
    require(!hasVoted[msg.sender], "Voter have voted already ");
    require(votingTokens[msg.sender] > 0, "Voter has no voting tokens");

    votingTokens[msg.sender] -= 1;
    votesRecieved[_candidate] += 1;
    hasVoted[msg.sender] = true;
    hasParticipated[msg.sender] = true;
    voterslist.push(msg.sender);  
    
}

function validateCandidate(address _candidate) view public returns(bool) {
    for(uint i = 0; i < candidateList.length; i++){
        if(candidateList[i] == _candidate){
            return true;
        }
    }
    return false;
}

function getVotesCount(address _candidate) public view onlyRunning returns(uint) {
    require(validateCandidate(_candidate), "Candidate Not valid ");
    return votesRecieved[_candidate];
}

function result() public onlyOwner {
    require(status == VotingStatus.Completed, "voting process going on");
    for(uint i = 0; i < candidateList.length; i++){
        if(votesRecieved[candidateList[i]] > winnerVotes){
            winnerVotes = votesRecieved[candidateList[i]];
            winner = candidateList[i];
        }
    }
}

function getWinner() public view returns (address) {
    require(status == VotingStatus.Completed, "Voting is not completed yet");
    require(winner != address(0), "Winner has not been determined yet");
    
    return winner;
}
function getWinnerVotes() public view returns (uint) {
    require(status == VotingStatus.Completed, "Voting is not completed yet");
    require(winner != address(0), "Winner has not been determined yet");
    
    return winnerVotes;
}
function getCandidateList() public view returns (address[] memory) {
    return candidateList;
}

function getVotersList() public view returns (address[] memory) { //get the list of people participated for election to vote
    require(status == VotingStatus.Completed, "Voting is not completed yet");
    return voterslist;
}
function getStatusText() public view returns (string memory) { //get status of the voting
    if (status == VotingStatus.NotStarted) {
        return "NotStarted";
    } else if (status == VotingStatus.Running) {
        return "Running";
    } else {
        return "Completed";
    }
}

function deposit() external payable { //can send assets to smart contract
}

  
function withdraw(address payable _to, uint _amount) external nonReentrant onlyOwner{ //can send assets from smart contract 
    require(msg.sender == owner(), "Only the owner can withdraw funds");
        _to.transfer(_amount);
}

  

function getBalance() external view returns(uint){ //get the balance of the contract by any voter 
        return address(this).balance;
} 

function getAddress() external view returns(address) {
    require(msg.sender == owner(), "Only the owner ");
        return address(this);
}

}


address[] public candidateList;
address[] public voterslist;

mapping(address => uint256) public votingTokens;
mapping (address => uint8) public votesRecieved;
mapping(address => bool) public hasVoted;
mapping(address => bool) public hasParticipated;


address public winner;
uint public winnerVotes;

enum VotingStatus { NotStarted, Running, Completed }
VotingStatus public status;


modifier onlyRunning() {
    require(status == VotingStatus.Running, "Election is not active");
    _;
}

function setStatus() public onlyOwner {
    if (status != VotingStatus.Completed && status != VotingStatus.Running){
        status = VotingStatus.Running;
    }
    else {
        status = VotingStatus.Completed;
    }
}

function resetVoting() external onlyOwner {
    require(status == VotingStatus.Completed, "Voting must be completed before it can be reset.");
    require(candidateList.length > 0, "There are no candidates registered to reset.");
    
    for (uint i = 0; i < candidateList.length; i++) {
        delete votesRecieved[candidateList[i]];
    }
    delete candidateList;
    delete voterslist;
    delete winner;
    winnerVotes = 0;
    status = VotingStatus.NotStarted;
}


function registerCandidate(address _candidate) public onlyOwner {
    require(!validateCandidate(_candidate), "Candidate is already registered");
    candidateList.push(_candidate);
}

function vote(address _candidate) public onlyRunning {
    require(validateCandidate(_candidate), " Candidate Not valid");
    require(!hasVoted[msg.sender], "Voter have voted already ");
    require(votingTokens[msg.sender] > 0, "Voter has no voting tokens");

    votingTokens[msg.sender] -= 1;
    votesRecieved[_candidate] += 1;
    hasVoted[msg.sender] = true;
    hasParticipated[msg.sender] = true;
    voterslist.push(msg.sender);  
    
}

function validateCandidate(address _candidate) view public returns(bool) {
    for(uint i = 0; i < candidateList.length; i++){
        if(candidateList[i] == _candidate){
            return true;
        }
    }
    return false;
}

function getVotesCount(address _candidate) public view onlyRunning returns(uint) {
    require(validateCandidate(_candidate), "Candidate Not valid ");
    return votesRecieved[_candidate];
}

function result() public onlyOwner {
    require(status == VotingStatus.Completed, "voting process going on");
    for(uint i = 0; i < candidateList.length; i++){
        if(votesRecieved[candidateList[i]] > winnerVotes){
            winnerVotes = votesRecieved[candidateList[i]];
            winner = candidateList[i];
        }
    }
}

function getWinner() public view returns (address) {
    require(status == VotingStatus.Completed, "Voting is not completed yet");
    require(winner != address(0), "Winner has not been determined yet");
    
    return winner;
}

function getWinnerVotes() public view returns (uint) {
    require(status == VotingStatus.Completed, "Voting is not completed yet");
    require(winner != address(0), "Winner has not been determined yet");
    
    return winnerVotes;
}
function getCandidateList() public view returns (address[] memory) {
    return candidateList;
}

function getVotersList() public view returns (address[] memory) { //get the list of people participated for election to vote
    require(status == VotingStatus.Completed, "Voting is not completed yet");
    return voterslist;
}
function getStatusText() public view returns (string memory) { //get status of the voting
    if (status == VotingStatus.NotStarted) {
        return "NotStarted";
    } else if (status == VotingStatus.Running) {
        return "Running";
    } else {
        return "Completed";
    }
}

function deposit() external payable { //can send assets to smart contract
}

function withdraw(address payable _to, uint _amount) external nonReentrant onlyOwner{ //can send assets from smart contract 
    require(msg.sender == owner(), "Only the owner can withdraw funds");
        _to.transfer(_amount);
} 

function getBalance() external view returns(uint){ //get the balance of the contract by any voter 
        return address(this).balance;
} 

function getAddress() external view returns(address) {
    require(msg.sender == owner(), "Only the owner ");
        return address(this);
}

}




































// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.7;

// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


// contract Voting is ERC20,Ownable,ReentrancyGuard {

//     constructor() ERC20("Voting", "VT") {}

//     function mint(address account, uint256 amount) public onlyOwner {  //creating tokens
//         _mint(account, amount);
//     }

//     function getTokenBalance(address account) public view returns (uint256) {
//     return balanceOf(account);
//     }

//     function transferToContract(uint256 amount) public {
//     require(balanceOf(msg.sender) >= amount, "Not enough tokens");

//     // Transfer tokens to contract
//     transfer(address(this), amount);
//     }



// address[] public candidateList;
// address[] public voterslist;

// mapping (address => uint8) public votesRecieved;
// mapping(address => bool) public hasVoted;
// mapping(address => bool) public hasParticipated;


// address public winner;
// uint public winnerVotes;

// enum VotingStatus { NotStarted, Running, Completed }
// VotingStatus public status;


// modifier onlyRunning() {
//     require(status == VotingStatus.Running, "Election is not active");
//     _;
// }

// function setStatus() public onlyOwner {
//     if (status != VotingStatus.Completed && status != VotingStatus.Running){
//         status = VotingStatus.Running;
//     }
//     else {
//         status = VotingStatus.Completed;
//     }
// }

// function resetVoting() external onlyOwner {
//     require(status == VotingStatus.Completed, "Voting must be completed before it can be reset.");
//     require(candidateList.length > 0, "There are no candidates registered to reset.");
    
//     for (uint i = 0; i < candidateList.length; i++) {
//         delete votesRecieved[candidateList[i]];
//     }
//     delete candidateList;
//     delete voterslist;
//     delete winner;
//     winnerVotes = 0;
//     status = VotingStatus.NotStarted;
// }


// function registerCandidate(address _candidate) public onlyOwner {
//     require(!validateCandidate(_candidate), "Candidate is already registered");
//     candidateList.push(_candidate);
// }

// function vote(address _candidate) public onlyRunning {
//     require(validateCandidate(_candidate), "Not a valid Candidate");
//     require(!hasVoted[msg.sender], "You have already voted");
//     votesRecieved[_candidate] += 1;
//     hasVoted[msg.sender] = true;
//     hasParticipated[msg.sender] = true;
//     voterslist.push(msg.sender);
    
// }

// function validateCandidate(address _candidate) view public returns(bool) {
//     for(uint i = 0; i < candidateList.length; i++){
//         if(candidateList[i] == _candidate){
//             return true;
//         }
//     }
//     return false;
// }

// function getVotesCount(address _candidate) public view onlyRunning returns(uint) {
//     require(validateCandidate(_candidate), "Not a valid Candidate");
//     return votesRecieved[_candidate];
// }

// function result() public onlyOwner {
//     require(status == VotingStatus.Completed, "voting is not completed");
//     for(uint i = 0; i < candidateList.length; i++){
//         if(votesRecieved[candidateList[i]] > winnerVotes){
//             winnerVotes = votesRecieved[candidateList[i]];
//             winner = candidateList[i];
//         }
//     }
// }

// function getWinner() public view returns (address) {
//     require(status == VotingStatus.Completed, "Voting is not completed yet");
//     require(winner != address(0), "Winner has not been determined yet");
    
//     return winner;
// }
// function getWinnerVotes() public view returns (uint) {
//     require(status == VotingStatus.Completed, "Voting is not completed yet");
//     require(winner != address(0), "Winner has not been determined yet");
    
//     return winnerVotes;
// }
// function getCandidateList() public view returns (address[] memory) {
//     return candidateList;
// }

// function getVotersList() public view returns (address[] memory) { //get the list of people participated for election to vote
//     require(status == VotingStatus.Completed, "Voting is not completed yet");
//     return voterslist;
// }
// function getStatusText() public view returns (string memory) {
//     if (status == VotingStatus.NotStarted) {
//         return "NotStarted";
//     } else if (status == VotingStatus.Running) {
//         return "Running";
//     } else {
//         return "Completed";
//     }
// }

// function deposit() external payable {
// }

  
// function withdraw(address payable _to, uint _amount) external nonReentrant onlyOwner{
//     require(msg.sender == owner(), "Only the owner can withdraw funds");
//         _to.transfer(_amount);
// }

  

// function getBalance() external view returns(uint){
//         return address(this).balance;
// } 

// function getAddress() external view returns(address) {
//     require(msg.sender == owner(), "Only the owner ");
//         return address(this);
// }

// }
