// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

struct Order {
    uint256 orderId;
    address seller;
    uint256 numberOfTokens;
    bool isActive;
}