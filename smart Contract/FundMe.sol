//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./PriceConverter.sol";

//to make gas efficient we r gonna twick some lines
// by using constant and immutable keyword

contract FundMe {
    using PriceConverter for uint256;
    // uint256 public number;
    uint256 public constant MINIMUM_USD = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    // function callMeRightAway(){

    // } instead of usinf function we will use constructor
    //constructor is made to set the limit for withdraw function to be accessde by owner of contract

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender; //setting by =
    }

    function fund() public payable {
        // number = 5;
        //want to able to set a minimum amount in Usd
        //how do we send eth to this contract
        require(msg.value.getConversionRate() >= MINIMUM_USD, "not enough eth");
        //revert in above line after comma it is in action when condition is not fulfilled
        //now if the txn is not completed due to condition is not met then
        //number will not updated and will remain 0 after deploy but if condition
        //is true number will be updated as 5 after deploy.
        //oracle and chainlink are used to convert ethereum in USD
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        // require(msg.sender == owner, "Sender is not owner!");  //checking by ==
        //for loop
        // starting index ; ending index ; increment in amount
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex = funderIndex + 1
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //reset the funder array
        funders = new address[](0);
        //withdraw the funds
        // threee diff way to do it
        //transfer    send    call

        // //msg.sender = address
        // //payable(msg.sender) = payble address
        // payable(msg.sender).transfer(address(this).balance);  //this refer to whole contract
        // //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send Failed");
        //call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "call failed"); //now we r going to use this
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Sender is not owner!");
        _;
    }
}
