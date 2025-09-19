// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AdvancedFeatures {
    struct User {
        uint256 balance;
        uint256 operations;
    }

    mapping(address => User) private users;
    uint256[] private history;

    function deposit(uint256 amount) public {
        require(amount > 0, "amount zero");
        users[msg.sender].balance += amount;
        users[msg.sender].operations += 1;
        history.push(amount);
    }

    function withdraw(uint256 amount) public {
        User storage user = users[msg.sender];
        require(user.balance >= amount, "insufficient");
        user.balance -= amount;
        user.operations += 1;
    }

    function getUser(address account) public view returns (uint256 balance, uint256 operations) {
        User storage user = users[account];
        return (user.balance, user.operations);
    }

    function historySum() public view returns (uint256) {
        uint256 sum = 0;
        for (uint256 i = 0; i < history.length; i++) {
            sum += history[i];
        }
        return sum;
    }

    function historyAverage() public view returns (uint256) {
        uint256 length = history.length;
        if (length == 0) {
            return 0;
        }
        return historySum() / length;
    }

    function factorial(uint256 n) public pure returns (uint256) {
        if (n == 0) {
            return 1;
        }
        uint256 result = 1;
        for (uint256 i = 2; i <= n; i++) {
            result *= i;
        }
        return result;
    }

    function fib(uint256 n) public pure returns (uint256) {
        if (n == 0) {
            return 0;
        }
        if (n == 1) {
            return 1;
        }
        uint256 prev = 0;
        uint256 curr = 1;
        for (uint256 i = 2; i <= n; i++) {
            uint256 next = prev + curr;
            prev = curr;
            curr = next;
        }
        return curr;
    }
}
