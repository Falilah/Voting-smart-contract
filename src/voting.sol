// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;
contract Voting{
/////////////////*****STATE VARIABLES ******////////////////////////



/////////////////*****STRUCTS ******////////////////////////


struct VotingPoll{
    address chairman;
    address[] candidates;
    uint32 maxNoOfCandidates;
    uint32 currentNoOfCandidates;
    mapping(address=>bool)  CandidateStatus;
    mapping(address=>bool) hasVoted;
    mapping (address => uint)  CandidateVote;
    bool voting;




}



/////////////////*****ARRAY ******////////////////////////





/////////////////*****MAPPINGS *////////////////////////
mapping(string => VotingPoll) public votingPoll;


  mapping (address => uint256) public replayNonce;

/////////////////*****EVENTS ******////////////////////////

event voted(address _candidate, bool status);
event becameCandidate(address NewCandidate);
event pollCreated(string indexed _name, uint32 indexed ExpectedNoOfCandidate, address indexed chairman);
event voteStatus(bool indexed status);

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


function createPoll(string memory _name, uint32 ExpectedNoOfCandidate) external returns(string memory, uint Candidate){
    VotingPoll storage VP = votingPoll[_name];
    VP.chairman = msg.sender;
    VP.maxNoOfCandidates =ExpectedNoOfCandidate;
    emit pollCreated( _name, VP.maxNoOfCandidates, VP.chairman);

    return(_name, ExpectedNoOfCandidate);
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

 function vote(address Cand, string memory _name , uint256 nonce, bytes memory signature) external  isCandidate(Cand, _name) StillVoting(_name){
     bytes32 metaHash = metaVotingHash(Cand,_name,nonce,block.timestamp);
     address signer = getSigner(metaHash,signature);
     require(signer!=address(0));
    require(nonce == replayNonce[signer]);
    replayNonce[signer]++;
     VotingPoll storage VP = votingPoll[_name];
     require(VP.hasVoted[signer] == false, "You already voted");

     countVote(Cand, _name, signer);
     emit voted(Cand, true);

 }
  function countVote(address Cand, string memory _name, address signer) internal returns(uint){
     VotingPoll storage VP = votingPoll[_name];
     VP.hasVoted[signer] = true;
     VP.CandidateVote[Cand]++;
     return VP.CandidateVote[Cand];
  }

  function setVotingState( string memory _name) external {
    VotingPoll storage VP = votingPoll[_name];
    require(VP.chairman == msg.sender, "not the chairman");     
     VP.voting = !(VP.voting);
     emit voteStatus(VP.voting);
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
     require(VP.chairman != address(0), "No poll created");
     CV = new uint[](VP.candidates.length);
     uint highestVote;
     address winner;
     for (uint i =0; i <= VP.candidates.length; i++){
       uint val = getPosition(_name,i);
     if(val > highestVote){
         highestVote = val; 
         winner = VP.candidates[i];
     }
     CV[i] = (VP.CandidateVote[VP.candidates[i]]);

     }
     return (CV, winner, highestVote);
 }

 

 function getPosition( string memory _name, uint i) internal view returns(uint val){
     VotingPoll storage VP = votingPoll[_name];
       val = VP.CandidateVote[VP.candidates[i]];
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


}