// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import {GasContract} from "../../src/Lesson7/Gas.sol";

contract GasContractTest is Test {
    GasContract public gasContract;

    address private OWNER;
    address private addr1;
    address private addr2;
    address private addr3;

    address private constant ADMIN1 =
        0x3243Ed9fdCDE2345890DDEAf6b083CA4cF0F68f2;
    address private constant ADMIN2 =
        0x2b263f55Bf2125159Ce8Ec2Bb575C649f822ab46;
    address private constant ADMIN3 =
        0x0eD94Bc8435F3189966a49Ca1358a55d871FC3Bf;
    address private constant ADMIN4 =
        0xeadb3d065f8d15cc05e92594523516aD36d1c834;

    address[5] private admins;

    uint256 private constant TOTAL_SUPPLY = 10000;

    function setUp() public {
        OWNER = makeAddr("OWNER");
        addr1 = makeAddr("addr1");
        addr2 = makeAddr("addr2");
        addr3 = makeAddr("addr3");

        // address[] memory admins = new address[](5);
        admins[0] = ADMIN1;
        admins[1] = ADMIN2;
        admins[2] = ADMIN3;
        admins[3] = ADMIN4;
        admins[4] = OWNER;

        vm.prank(OWNER);
        gasContract = new GasContract(admins, TOTAL_SUPPLY);
    }

    function testGasContractAdmins() public {
        assertEq(gasContract.administrators(0), ADMIN1, "ADMIN1");
        assertEq(gasContract.administrators(1), ADMIN2, "ADMIN2");
        assertEq(gasContract.administrators(2), ADMIN3, "ADMIN3");
        assertEq(gasContract.administrators(3), ADMIN4, "ADMIN4");
        assertEq(gasContract.administrators(4), OWNER, "OWNER");
    }

    function testGasContractTotalSupply() public {
        assertEq(gasContract.totalSupply(), TOTAL_SUPPLY, "totalSupply");
    }

    function testGasContractTransfer() public {
        vm.prank(OWNER);
        gasContract.transfer(addr1, 100, "acc1");
        assertEq(gasContract.balanceOf(addr1), 100);
    }

    function testGasContractCheckUpdate() public {
        vm.startPrank(OWNER);
        gasContract.transfer(addr1, 300, "acc1");
        gasContract.transfer(addr1, 200, "acc1");
        gasContract.transfer(addr1, 100, "acc1");
        gasContract.transfer(addr2, 300, "acc2");
        gasContract.transfer(addr2, 100, "acc2");
        assertEq(gasContract.balanceOf(addr1), 600);
        assertEq(gasContract.balanceOf(addr2), 400);
        gasContract.updatePayment(
            OWNER,
            1,
            302,
            GasContract.PaymentType.Dividend
        );
        GasContract.Payment[] memory payments = gasContract.getPayments(OWNER);
        assertEq(payments.length, 5);
        assertEq(payments[0].recipientName, "acc1");
        assertEq(payments[0].amount, 302);
        assertEq(
            uint256(payments[0].paymentType),
            uint256(GasContract.PaymentType.Dividend)
        );
        vm.stopPrank();
    }

    event Transfer(address indexed recipient, uint256 amount);

    function testGasContractEvents() public {
        vm.startPrank(OWNER);
        vm.expectEmit(true, true, false, true);
        emit Transfer(addr1, 300);
        gasContract.transfer(addr1, 300, "acc1");
        vm.stopPrank();
    }

    function testCheckForAdmin() public {
        vm.expectRevert(GasContract.NotAdminOrOwner.selector);
        vm.prank(addr1);
        gasContract.updatePayment(
            OWNER,
            1,
            302,
            GasContract.PaymentType.Dividend
        );
    }

    function testEnsureTradingModeIsSet() public {
        assertEq(gasContract.getTradingMode(), true);
    }

    function testAddUsersToWhitelistAndValidateKeyUsersTier() public {
        _addToWhiteList();
        assertEq(gasContract.whitelist(addr1), 1);
        assertEq(gasContract.whitelist(addr2), 2);
        assertEq(gasContract.whitelist(addr3), 3);
    }

    function testWhitelistWorks() public {
        _addToWhiteList();

        vm.startPrank(OWNER);
        gasContract.transfer(addr1, 500, "acc1");
        gasContract.transfer(addr2, 300, "acc1");
        gasContract.transfer(addr3, 100, "acc1");
        vm.stopPrank();

        address recipient1 = vm.addr(1000);
        address recipient2 = vm.addr(1001);
        address recipient3 = vm.addr(1002);

        uint256 sendValue1 = 250;
        uint256 sendValue2 = 150;
        uint256 sendValue3 = 50;

        vm.prank(addr1);
        gasContract.whiteTransfer(recipient1, sendValue1);

        vm.prank(addr2);
        gasContract.whiteTransfer(recipient2, sendValue2);

        vm.prank(addr3);
        gasContract.whiteTransfer(recipient3, sendValue3);

        assertEq(gasContract.balanceOf(recipient1), sendValue1 - 1);
        assertEq(gasContract.balanceOf(recipient2), sendValue2 - 2);
        assertEq(gasContract.balanceOf(recipient3), sendValue3 - 3);

        assertEq(gasContract.balanceOf(addr1), sendValue1 + 1);
        assertEq(gasContract.balanceOf(addr2), sendValue2 + 2);
        assertEq(gasContract.balanceOf(addr3), sendValue3 + 3);
    }

    function _addToWhiteList() private {
        vm.startPrank(OWNER);

        gasContract.addToWhitelist(addr1, 1);
        for (uint256 i = 0; i < 99; i++) {
            gasContract.addToWhitelist(vm.addr(1), 1);
        }

        gasContract.addToWhitelist(addr2, 2);
        for (uint256 i = 0; i < 199; i++) {
            gasContract.addToWhitelist(vm.addr(1), 2);
        }

        gasContract.addToWhitelist(addr3, 3);
        for (uint256 i = 0; i < 299; i++) {
            gasContract.addToWhitelist(vm.addr(1), 3);
        }

        vm.stopPrank();
    }
}
