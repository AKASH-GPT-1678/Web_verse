// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "./IdentityInterfcae.sol";

contract Subscription {
    IIdentitySBT public identityContract;
    uint public silver = 0.01 ether;
    uint public gold = 0.02 ether;
    uint public platinum = 0.05 ether;

    enum Type {
        Silver,
        Gold,
        Platinum
    }
    enum Status {
        ACTIVE,
        INACTIVE
    }
    struct Subscriber {
        address _useraddress;
        string username;
        Type types;
        uint expireDate;
        Status status;
    }
    event SubscriptionCreated(
        address indexed _useraddress,
        string _username,
        Type _type,
        uint _expireDate
    );
    mapping(address => Subscriber) _subscriptions;
    mapping(address => bool) _isSubscribed;

    constructor(address _identity) {
        identityContract = IIdentitySBT(_identity);
    }

    function getSubscriptionType(uint _amount) public view returns (Type) {
        if (_amount == silver) {
            return Type.Silver;
        } else if (_amount == gold) {
            return Type.Gold;
        } else if (_amount == platinum) {
            return Type.Platinum;
        } else {
            revert("Invalid amount");
        }
    }

    modifier onlySBTowner() {
        require(
            identityContract.hasIdentity(msg.sender),
            "User does not have an SBT"
        );
        _;
    }

    function createSuhscription(
        string memory _username
    ) public payable onlySBTowner {
        require(
            _isSubscribed[msg.sender] == false,
            "User already has an active subscription"
        );
        Type _type = getSubscriptionType(msg.value);
        _subscriptions[msg.sender] = Subscriber(
            msg.sender,
            _username,
            _type,
            block.timestamp + 30 days,
            Status.ACTIVE
        );
        _isSubscribed[msg.sender] = true;
        emit SubscriptionCreated(
            msg.sender,
            _username,
            _type,
            block.timestamp + 30 days
        );
    }

    function deleteSubscription() public onlySBTowner {
        delete _subscriptions[msg.sender];
        _isSubscribed[msg.sender] = false;
    }

    function renewSubscription() public payable {
        require(
            _isSubscribed[msg.sender] == true,
            "You do not have an active subscription"
        );
        require(
            _subscriptions[msg.sender].status != Status.ACTIVE,
            "You arleady have active subscripition"
        );

        Type _types = getSubscriptionType(msg.value);
        _subscriptions[msg.sender].status = Status.ACTIVE;
        _subscriptions[msg.sender].expireDate = block.timestamp + 30 days;
        _subscriptions[msg.sender].types = _types;
    }

    function cancelSubscription() public {
        require(_isSubscribed[msg.sender] == true, "Must be Existing User");
        _subscriptions[msg.sender].status = Status.INACTIVE;
    }

    function getSubscription() public returns (Subscriber memory) {
        require(_isSubscribed[msg.sender] == true, "Must be Existing User");
        if (_subscriptions[msg.sender].expireDate < block.timestamp) {
            _subscriptions[msg.sender].status = Status.INACTIVE;
        }
        return _subscriptions[msg.sender];
    }
}
