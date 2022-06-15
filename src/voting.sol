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


  mapping (address => uint256) public replayNonce;

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

function createId(string memory _name) public payable{
    VotingPoll storage VP = votingPoll[_name];
    require(msg.value >= VP.regFee, "payment is less than the required registration fee");
    VP.ParticipantStatus[msg.sender] == true;
    uint refund = msg.value - VP.regFee;
    if(refund > 0){
        payable(msg.sender).transfer(refund);
    }
    VP.amountGenerated += VP.regFee;
    emit registeredAsVoter(true);

}
 function AddCandidate(address _newCandidate, string memory _name) external{
     VotingPoll storage VP = votingPoll[_name];
     require (VP.chairman != address(0) , "yet to create a poll");  
     assert(VP.chairman == msg.sender);
     require(VP.currentNoOfCandidates < VP.maxNoOfCandidates, "maximum no of candidate per session registered");
     VP.CandidateStatus[_newCandidate] = true; 
     VP.candidates.push(_newCandidate); 
     VP.currentNoOfCandidates++;
     emit becameCandidate(_newCandidate);
 }

 function vote(address Cand, string memory _name, uint256 nonce, bytes memory signature) external  isCandidate(Cand, _name) StillVoting(_name){
     bytes32 metaHash = metaVotingHash(Cand,_name,nonce,block.timestamp);
     address signer = getSigner(metaHash,signature);
     require(signer!=address(0));
    require(nonce == replayNonce[signer]);
    replayNonce[signer]++;
     VotingPoll storage VP = votingPoll[_name];
     require(VP.ParticipantStatus[signer] == true, "You did not registerd for this vote");
     require(VP.hasVoted[signer] == false, "You already voted");

     countVote(Cand, _name, signer);
     emit voted(Cand, true);

 }
  function countVote(address Cand, string memory _name, address signer) internal {
     VotingPoll storage VP = votingPoll[_name];
     VP.hasVoted[signer] = true;
     VP.CandidateVote[Cand]++;
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



 function metaVotingHash(address Cand, string memory _name, uint256 nonce, uint256 time) public view returns(bytes32){
    return keccak256(abi.encodePacked(address(this),"metatransaction Voting ", Cand, _name, nonce, time));
  }

  function getSigner(bytes32 _hash, bytes memory _signature) internal pure returns (address){
    bytes32 r;
    bytes32 s;
    uint8 v;
    if (_signature.length != 65) {
      return address(0);
    }
    assembly {
      r := mload(add(_signature, 32))
      s := mload(add(_signature, 64))
      v := byte(0, mload(add(_signature, 96)))
    }
    if (v < 27) {
      v += 27;
    }
    if (v != 27 && v != 28) {
      return address(0);
    } else {
      return ecrecover(keccak256(
        abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
      ), v, r, s);
    }
  }

receive() external payable {}


}