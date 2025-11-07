//SPDX-Licence-Identifier: MIT
pragma solidity ^0.8.18;

contract Subscription {
    uint public silver = 0.01 ether;
    uint public gold = 0.02 ether;
    uint public platinum = 0.05 ether;
    uint balance;

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
        string email;
        string username;
        Type types;
        uint expireDate;
        Status status;
    }
    mapping(string email => Subscriber) _subscriptions;

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

    function createSubscription(
        string memory _email,
        string memory _username
    ) public payable {
        Type _type = getSubscriptionType(msg.value);
        uint expireDate = block.timestamp + 30 days;

        _subscriptions[_email] = Subscriber({
            email: _email,
            username: _username,
            types: _type,
            expireDate: expireDate,
            status: Status.ACTIVE
        });
        balance += msg.value;
    }

    function renewSubscription(string memory _email) public payable {
        require(
            bytes(_subscriptions[_email].email).length > 0,
            "Must be Existing User"
        );
        require(
            _subscriptions[_email].status != Status.ACTIVE,
            "You arleady have active subscripition"
        );
        Type _status = getSubscriptionType(msg.value);
        _subscriptions[_email].status = Status.ACTIVE;
        _subscriptions[_email].expireDate = block.timestamp + 30 days;
        _subscriptions[_email].types = _status;
    }

    function cancelSubscription(string memory _email) public {
        require(
            bytes(_subscriptions[_email].email).length > 0,
            "Must be Existing User"
        );
        _subscriptions[_email].status = Status.INACTIVE;
    }

    function getSubscription(
        string memory _email
    ) public  returns (Subscriber memory) {
        require(
            bytes(_subscriptions[_email].email).length > 0,
            "Must be Existing User"
        );
        if (_subscriptions[_email].expireDate < block.timestamp) {
            _subscriptions[_email].status = Status.INACTIVE;
        }
        return _subscriptions[_email];
    }

    function deleteSubscription(string memory _email) public {
        require(
            bytes(_subscriptions[_email].email).length > 0,
            "Must be Existing User"
        );
        delete _subscriptions[_email];
    }
}
