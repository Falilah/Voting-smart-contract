// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;
contract Voting{
/////////////////*****STATE VARIABLES ******////////////////////////

uint256 candidateFee= 20000000000000000000;//200tokens
uint256 public regFee= 40000000000000000000 ether;//40tokens
address chairman;
uint32 CurrentCandidate;
uint32 maxNoOfCandidates;

/////////////////*****STRUCTS ******////////////////////////

struct Candidate{
    uint voteCount;
}


address[] public Candidates;

/////////////////*****MAPPINGS *////////////////////////

mapping (address => Candidate) public CandidateVote;
mapping(address=>bool) public ParticipantStatus;
mapping(address=>bool) public CandidateStatus;
mapping(address=>bool) private hasVoted;


/////////////////*****EVENTS ******////////////////////////

event voted(address _candidate, bool status);
event becameCandidate(address NewCandidate);
event registeredAsVoter(bool success);

/////////////////*****MODIFIERS *****////////////////////////

modifier isCandidate(address Cand){
    require(CandidateStatus[Cand]==true,'This address does not exist as a candidate');
    _;
}

modifier isParticipant( address part){
    require(ParticipantStatus[part]==true, 'this person has not registered as a participant to vote');
    _;
}

/////////////////*****CONSTRUCTORS ******////////////////////////

constructor(address _chairman, uint _maxCandidate) {
    chairman = _chairman;
    maxNoOfCandidates = uint32(_maxCandidate);

}

/////////////////*****FUNCTIONS ******////////////////////////

function createId() public payable {
    require(msg.value >= regFee, "payment is less than the required registration fee fee");
    require( ParticipantStatus[msg.sender] == false, "you are a registered member");
    ParticipantStatus[msg.sender] == true;
    uint refund = msg.value - regFee + candidateFee;
    if(refund > 0){
        payable(msg.sender).transfer(refund);
    }
    

}
 function AddCandidate(address _newCandidate) external isParticipant(_newCandidate){
     require (msg.sender == chairman, "not the chairman");   
     require(CurrentCandidate < maxNoOfCandidates, "maximum no of candidate per session registered");
     CandidateStatus[_newCandidate] = true; 
     Candidates.push(_newCandidate); 
     CurrentCandidate++;
     emit becameCandidate(_newCandidate);
 }
 function vote(address Cand) external  isCandidate(Cand){
     require( ParticipantStatus[msg.sender] == true, "not a registered member");
     require(hasVoted[msg.sender] == false, "You already voted");
     hasVoted[msg.sender] = true;
     CandidateVote[Cand].voteCount++;

     emit voted(Cand, true);

 }

 function NoOfRegisteredCandidates() public view returns(uint){
     return CurrentCandidate;
 }

 

 function AllCandidates() public view returns(address[] memory _candidates){
     return Candidates;
 }

 function revealWinner() external view returns ( Candidate[] memory CV, address, uint){
     CV = new Candidate[](Candidates.length);
     uint highestVote;
     address winner;
     for (uint i =0; i <= Candidates.length; i++){
     if(CandidateVote[Candidates[i]].voteCount > highestVote){
         highestVote = CandidateVote[Candidates[i]].voteCount; 
         winner = Candidates[i];
     }
     CV[i] = (CandidateVote[Candidates[i]]);

     }
     return (CV, winner, highestVote);
 }

function withdawFees() external payable{
     require(msg.sender == chairman, "not the chairman");
     payable(msg.sender).transfer(address(this).balance);

 }


}