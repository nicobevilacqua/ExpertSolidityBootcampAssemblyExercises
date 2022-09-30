// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract GasContract is Ownable {
    /**
        STRUCTS
     */
    struct ImportantStruct {
        uint256 valueA; // max 3 digits
        uint256 bigValue;
        uint256 valueB; // max 3 digits
    }

    struct Payment {
        PaymentType paymentType;
        uint256 paymentID;
        uint256 amount;
        address admin; // administrators address
        bool adminUpdated;
        address recipient;
        bytes8 recipientName; // max 8 characters
    }

    enum PaymentType {
        Unknown,
        BasicPayment,
        Refund,
        Dividend,
        GroupPayment
    }

    /**
        CONSTANTS
     */
    uint256 public immutable totalSupply;

    /**
        PRIVATE STORAGE
     */
    uint256 private paymentCounter;
    mapping(address => Payment[]) private payments;
    mapping(address => uint256) private balances;

    /**
        PUBLIC STORAGE
     */
    mapping(address => uint256) public whitelist;
    address[5] public administrators;

    /**
        CUSTOM ERRORS
     */
    error NotAdminOrOwner();
    error NotWhitelisted();
    error IncorrectTier();
    error InsufficientBalance(uint256 balance, uint256 amount);
    error RecipientNameTooLong();
    error InvalidPaymentId();
    error InvalidPaymentAmount();
    error InvalidPaymentUser();
    error WhiteTransferInsufficientBalance();
    error WhiteTransferAmountToSmall();
    error InvalidAdmin();

    /**
        EVENTS
     */
    event SupplyChanged(address indexed, uint256 indexed);
    event Transfer(address indexed recipient, uint256 amount);
    event PaymentUpdated(
        address indexed admin,
        uint256 indexed id,
        uint256 amount,
        string indexed recipient,
        uint256 blockNumber,
        uint256 lastUpdate,
        address updatedBy
    );
    event WhiteListTransfer(address indexed);
    event AddedToWhitelist(address userAddress, uint256 tier);

    /**
        MODIFIERS
     */
    modifier onlyAdminOrOwner() {
        if (!_checkForAdmin(msg.sender) && owner() != msg.sender) {
            revert NotAdminOrOwner();
        }
        _;
    }

    modifier checkIfWhiteListed() {
        uint256 usersTier = whitelist[msg.sender];
        if (usersTier == 0) {
            revert NotWhitelisted();
        }
        if (usersTier >= 4) {
            revert IncorrectTier();
        }
        _;
    }

    /**
        CONSTRUCTOR
     */
    constructor(address[5] memory _admins, uint256 _totalSupply) {
        totalSupply = _totalSupply;

        administrators = _admins;

        balances[msg.sender] = _totalSupply;

        emit SupplyChanged(msg.sender, _totalSupply);
    }

    /**
        VIEWS
     */
    function balanceOf(address _user) public view returns (uint256) {
        return balances[_user];
    }

    function getTradingMode() public pure returns (bool) {
        return true;
    }

    function getPayments(address _user)
        external
        view
        returns (Payment[] memory)
    {
        return payments[_user];
    }

    /**
        PUBLIC FUNCTIONS
     */
    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) external {
        if (balances[msg.sender] < _amount) {
            revert InsufficientBalance(balances[msg.sender], _amount);
        }

        if (bytes(_name).length >= 9) {
            revert RecipientNameTooLong();
        }

        unchecked {
            balances[msg.sender] -= _amount;
            balances[_recipient] += _amount;
        }

        payments[msg.sender].push(
            Payment({
                admin: address(0),
                adminUpdated: false,
                paymentType: PaymentType.BasicPayment,
                recipient: _recipient,
                amount: _amount,
                recipientName: bytes8(bytes(_name)),
                paymentID: ++paymentCounter
            })
        );

        emit Transfer(_recipient, _amount);
    }

    function updatePayment(
        address _user,
        uint256 _id,
        uint256 _amount,
        PaymentType _type
    ) external onlyAdminOrOwner {
        if (_id == 0) {
            revert InvalidPaymentId();
        }

        if (_amount == 0) {
            revert InvalidPaymentAmount();
        }

        if (_user == address(0)) {
            revert InvalidPaymentUser();
        }

        for (uint256 i = 0; i < payments[_user].length; ) {
            Payment storage payment = payments[_user][i];
            if (payment.paymentID == _id) {
                payment.adminUpdated = true;
                payment.admin = _user;
                payment.paymentType = _type;
                payment.amount = _amount;

                emit PaymentUpdated(
                    msg.sender,
                    _id,
                    _amount,
                    string(abi.encodePacked(payment.recipientName)),
                    block.number,
                    block.timestamp,
                    _user
                );
                break;
            }

            unchecked {
                ++i;
            }
        }
    }

    function addToWhitelist(address _userAddrs, uint8 _tier)
        external
        onlyAdminOrOwner
    {
        /**
            WEIRD TIER LOGIC
         */
        uint8 tier = _tier;
        if (_tier > 3) {
            tier = 3;
        } else if (_tier == 1) {
            tier = 1;
        } else if (_tier > 0 && _tier < 3) {
            tier = 2;
        }

        whitelist[_userAddrs] = _tier;

        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount,
        ImportantStruct calldata
    ) external checkIfWhiteListed {
        if (_amount <= 3) {
            revert WhiteTransferAmountToSmall();
        }

        uint256 userBalance = balances[msg.sender];

        if (userBalance < _amount) {
            revert WhiteTransferInsufficientBalance();
        }

        unchecked {
            balances[msg.sender] =
                userBalance -
                _amount +
                whitelist[msg.sender];
            balances[_recipient] =
                balances[_recipient] +
                _amount -
                whitelist[msg.sender];
        }

        emit WhiteListTransfer(_recipient);
    }

    /**
        PRIVATE FUNCTIONS
     */
    function _checkForAdmin(address _user) private view returns (bool) {
        for (uint256 i = 0; i < administrators.length; ) {
            if (administrators[i] == _user) {
                return true;
            }
            unchecked {
                ++i;
            }
        }
        return false;
    }
}
