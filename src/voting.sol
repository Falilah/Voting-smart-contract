// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;
contract Voting{
/////////////////*****STATE VARIABLES ******////////////////////////



/////////////////*****STRUCTS ******////////////////////////


struct VotingPoll{
    address chairman;
    address[] candidates;
    uint16 regFee;
    uint32 maxNoOfCandidates;
    uint64 startTime;
    uint64 amountGenerated;
    uint16 currentNoOfCandidates;
    bool voting;
    mapping(address=>bool)  CandidateStatus;
    mapping(address=>bool) ParticipantStatus;
    mapping(address=>bool) hasVoted;
    mapping (address => uint)  CandidateVote;



}


/////////////////*****ARRAY ******////////////////////////


/////////////////*****MAPPINGS *////////////////////////
mapping(string => VotingPoll) public votingPoll;

/////////////////*****EVENTS ******////////////////////////

event voted(address _candidate, bool status);
event becameCandidate(address NewCandidate);
event registeredAsVoter(bool success);

/////////////////*****MODIFIERS *****////////////////////////

modifier isCandidate(address Cand, string memory _name){
    VotingPoll storage VP = votingPoll[_name];
    require(VP.CandidateStatus[Cand]==true,'This address does not exist as a candidate');
    _;
}

modifier isParticipant( address part, string memory _name){
    VotingPoll storage VP = votingPoll[_name];
    require(VP.ParticipantStatus[part]==true, 'this person has not registered as a participant to vote');
    _;
}

modifier StillVoting(string memory _name){
    VotingPoll storage VP = votingPoll[_name];
    require(VP.voting == true, "voting has ended");

    _;
}

/////////////////*****CONSTRUCTORS ******////////////////////////



/////////////////*****FUNCTIONS ******////////////////////////


function createPoll(string memory _name,  uint _regFee, uint16 ExpectedNoOfCandidate) external {
    VotingPoll storage VP = votingPoll[_name];
    VP.regFee = uint16(_regFee);
    VP.chairman = msg.sender;
    VP.maxNoOfCandidates =ExpectedNoOfCandidate;
}

function createId(string memory _name) public payable isParticipant(msg.sender, _name){
    VotingPoll storage VP = votingPoll[_name];
    require(msg.value >= VP.regFee, "payment is less than the required registration fee fee");
    VP.ParticipantStatus[msg.sender] == true;
    uint refund = msg.value - VP.regFee;
    if(refund > 0){
        payable(msg.sender).transfer(refund);
    }
    VP.amountGenerated += VP.regFee;
    emit registeredAsVoter(true);

}
 function AddCandidate(address _newCandidate, string memory _name) external isParticipant(_newCandidate, _name){
     VotingPoll storage VP = votingPoll[_name];
     require (VP.chairman != address(0) , "yet to create a poll");   
     require(VP.currentNoOfCandidates < VP.maxNoOfCandidates, "maximum no of candidate per session registered");
     VP.CandidateStatus[_newCandidate] = true; 
     VP.candidates.push(_newCandidate); 
     VP.currentNoOfCandidates++;
     emit becameCandidate(_newCandidate);
 }
 function vote(address Cand, string memory _name) external  isCandidate(Cand, _name) isParticipant(msg.sender, _name) StillVoting(_name){
     VotingPoll storage VP = votingPoll[_name];
     require(VP.hasVoted[msg.sender] == false, "You already voted");
     VP.hasVoted[msg.sender] = true;
     VP.CandidateVote[Cand]++;
     emit voted(Cand, true);

 }

 function NoOfRegisteredCandidates( string memory _name) public view returns(uint){
     VotingPoll storage VP = votingPoll[_name];
     return VP.currentNoOfCandidates;
 }

 

 function AllCandidates( string memory _name) public view returns(address[] memory _candidates){
     VotingPoll storage VP = votingPoll[_name];
     return VP.candidates;
 }

 function revealWinner( string memory _name) external view returns ( uint[] memory CV, address, uint){
     VotingPoll storage VP = votingPoll[_name];
     CV = new uint[](VP.candidates.length);
     uint highestVote;
     address winner;
     for (uint i =0; i <= CV.length; i++){
     if(VP.CandidateVote[VP.candidates[i]] > highestVote){
         highestVote = VP.CandidateVote[VP.candidates[i]]; 
         winner = VP.candidates[i];
     }
     CV[i] = (VP.CandidateVote[VP.candidates[i]]);

     }
     return (CV, winner, highestVote);
 }

 function setVotingState( string memory _name) external {
    VotingPoll storage VP = votingPoll[_name];
    require(VP.chairman == msg.sender, "not the chairman");     
     VP.voting = !(VP.voting);
 }

function withdawFees(string memory _name) external payable{
    VotingPoll storage VP = votingPoll[_name];
     require(msg.sender == VP.chairman, "not the chairman");
     payable(msg.sender).transfer(VP.amountGenerated);
 }

receive() external payable {}


}