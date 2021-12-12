//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

    // Two players in this game and each of them makes a choice: head or tail
    //  "payable" required to allow the function
    // to receive from Ether
    contract heads_or_tails {
    uint256 price = 1000000000000000000;
    address payable owner;
    uint256 time_balance1=0;
    uint256 time_balance2=0;
    address payable time_player1;
    address payable time_player2;

    // constructor assigns the account that has deployed this contract as the owner --> will receive 5%.
    constructor()public {
        owner=payable(msg.sender);
    }

    // this is a control function allowing getting back gas if 
    // conditions are not met -> course 3.4: the whole transaction is reverted
    function Head () public payable {
        require (time_balance1==0, "A bet has already been placed on this");
        require (msg.value >=price , "Minimum amount for a bet - 1000000000000000000 Wei ");
        time_balance1 = 1000000000000000000; // course 3.4:  ether amount in wei sent with the message
        time_player1 = payable(msg.sender); // course 3.4: sender address of the message
    }

    function Tail () public payable {
        require (time_balance2==0,"A bet has already been placed on this");
        require (msg.value >=price , "Minimum amount for a bet - 1000000000000000000 Wei " );
        time_balance2 = 1000000000000000000;
        time_player2 = payable(msg.sender);
    }

    // 
    function bank() public payable{
        require (time_balance1>0 && time_balance2>0, "wait until the second player places a bet, upon completion the winner will receive 95% of the pot");
        uint256 sum = time_balance1+time_balance2;
        uint256 value =sum/100*95;
        owner.transfer(sum/100*5);
        // we cannot access block data for a specific transation but with block.difficulty it should work
        // block difficulty decides if it's head or tail that wins the game
        if (block.difficulty/1000000000000<7){
            time_player1.transfer(value);
        }
        else {
            time_player2.transfer(value);

        }
    }

    function see_timeb1 () public view returns (uint256){
        return time_balance1;
    }

    function see_timeb2 () public view returns (uint256){
        return time_balance2;

    
    }
}