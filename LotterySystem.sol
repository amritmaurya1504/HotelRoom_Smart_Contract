// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 < 0.9.0;

contract Lottery {
    address public manager;
    address payable[] public participants;
    
    constructor(){
        manager = msg.sender;
    }
    
    modifier costs (uint _amount){
        require(msg.value == 2 ether , "Not Enough Ether!");
        _;
    }
    
    receive() external payable costs(2 ether) {
        participants.push(payable(msg.sender));
    }
    
    modifier onlyOwner (){
        require(msg.sender == manager, "Access Denied!");
        _;
    }
    
    function getBalance() public onlyOwner view returns(uint){
        return address(this).balance;
    }
    
    function random() public view returns(uint){
        //random generator algorithm
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
        
    }
    
    modifier minParticipants (uint _minMem){
        require(participants.length >= _minMem, "Not Much participants participated!");
        _;
    }
    
    function selectWinner() public onlyOwner minParticipants(3){
        uint randomVal = random();
        address payable winner;
        uint index = randomVal % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        
        participants = new address payable[](0);
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}