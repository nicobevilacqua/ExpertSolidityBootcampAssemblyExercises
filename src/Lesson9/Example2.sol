// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Lesson9Example2 {
    // In this contract the students add themselves via the joinCourse function.
    // At a later time the teacher will via a front end call the welcomeStudents function
    // to send a message to the students and get the number of students starting the course.
    address[] students;
    address teacher = 0x94603d2C456087b6476920Ef45aD1841DF940475;

    event welcome(string, address);
    uint256 startingNumber = 0;

    function joinCourse() public {
        students.push(msg.sender);
    }

    function welcomeStudents() public {
        require(
            msg.sender == teacher,
            "Only the teacher can call this function"
        );
        for (uint256 x; x < students.length; x++) {
            emit welcome("Welcome to the course", students[x]);
            startingNumber++;
        }
    }
}
