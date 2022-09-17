// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Calend3 {
    uint256 rate;
    address payable public owner;

    struct Appointment {
        string title;
        address attendee;
        uint256 startTime;
        uint256 endTime;
        uint256 amountPaid;
    }

    Appointment[] appointments;

    constructor() {
        owner = payable(msg.sender);
    }

    function getRate() public view returns (uint256) {
        return rate;
    }

    function setRate(uint256 _rate) public {
        require(msg.sender == owner, "Only the owner can set the rate");
        rate = _rate;
    }

    function getAppointments() public view returns (Appointment[] memory) {
        return appointments;
    }

    function createAppointments(
        string memory title,
        uint256 startTime,
        uint256 endTime
    ) public payable {
        Appointment memory appointment;
        appointment.title = title;
        appointment.startTime = startTime;
        appointment.endTime = endTime;
        appointment.amountPaid = ((endTime - startTime) / 60) * rate;
        appointment.attendee = msg.sender;

        require(msg.value >= appointment.amountPaid, "We require more ether");
        (bool success, ) = owner.call{value: msg.value}("");
        require(success, "Failed to send Ether");
        appointments.push(appointment);
    }
}
