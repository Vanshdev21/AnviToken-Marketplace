// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {Order} from "./types/Trade.sol";

contract TokenMarketplace is ReentrancyGuard {
    using SafeERC20 for IERC20;

    uint256 public constant TOKEN_PRICE = 1 ether;

    IERC20 public immutable anviToken;

    uint256 private nextOrderId;
    uint256 private reservedTokens;

    mapping(uint256 => Order) private orders;

    // Custom Errors

    error ZeroTokenAmount();
    error IncorrectEthPayment(uint256 expected, uint256 received);
    error InsufficientMarketplaceBalance(uint256 available, uint256 requested);
    error InsufficientUserBalance(uint256 available, uint256 requested);
    error InsufficientTokenAllowance(uint256 available, uint256 required);
    error InvalidOrderId(uint256 orderId);
    error InactiveOrder(uint256 orderId);
    error InsufficientOrderTokens(uint256 available, uint256 requested);
    error UnauthorizedOrderCancellation();
    error EthTransferFailed();

    // Constructor

    constructor(address tokenAddress) {
        require(tokenAddress != address(0), "Invalid token address");
        anviToken = IERC20(tokenAddress);
    }

    // Internal Validation Functions

    function _validateTokenAmount(uint256 tokenAmount) internal pure {
        if (tokenAmount == 0) {
            revert ZeroTokenAmount();
        }
    }

    function _validateEthPayment(uint256 tokenAmount) internal view {
        uint256 expectedPayment = tokenAmount * TOKEN_PRICE;

        if (msg.value != expectedPayment) {
            revert IncorrectEthPayment(expectedPayment, msg.value);
        }
    }

    function _validateUserBalance(
        address account,
        uint256 tokenAmount
    ) internal view {
        uint256 userBalance = anviToken.balanceOf(account);

        if (userBalance < tokenAmount) {
            revert InsufficientUserBalance(userBalance, tokenAmount);
        }
    }

    function _validateMarketplaceBalance(uint256 tokenAmount) internal view {
        uint256 marketplaceBalance = anviToken.balanceOf(address(this));
        uint256 availableTokens = marketplaceBalance - reservedTokens;

        if (availableTokens < tokenAmount) {
            revert InsufficientMarketplaceBalance(availableTokens, tokenAmount);
        }
    }

    function _validateOrderId(uint256 orderId) internal view {
        if (orderId >= nextOrderId) {
            revert InvalidOrderId(orderId);
        }

        if (!orders[orderId].isActive) {
            revert InactiveOrder(orderId);
        }
    }

    function _validateOrderTokenAmount(
        Order storage order,
        uint256 tokenAmount
    ) internal view {
        if (order.numberOfTokens < tokenAmount) {
            revert InsufficientOrderTokens(order.numberOfTokens, tokenAmount);
        }
    }

    // Buy Tokens Directly From Marketplace

    function buyTokens(uint256 tokenAmount) external payable nonReentrant {
        _validateTokenAmount(tokenAmount);
        _validateEthPayment(tokenAmount);
        _validateMarketplaceBalance(tokenAmount);

        anviToken.safeTransfer(msg.sender, tokenAmount);
    }

    // Create Sell Order

    function createSellOrder(uint256 tokenAmount) external nonReentrant {
        _validateTokenAmount(tokenAmount);
        _validateUserBalance(msg.sender, tokenAmount);

        uint256 userAllowance = anviToken.allowance(msg.sender, address(this));

        if (userAllowance < tokenAmount) {
            revert InsufficientTokenAllowance(userAllowance, tokenAmount);
        }

        uint256 orderId = nextOrderId;

        orders[orderId] = Order({
            orderId: orderId,
            seller: msg.sender,
            numberOfTokens: tokenAmount,
            isActive: true
        });

        nextOrderId++;

        anviToken.safeTransferFrom(msg.sender, address(this), tokenAmount);

        reservedTokens += tokenAmount;
    }

    // Buy Tokens From Existing Sell Order

    function buyTokensFromOrder(
        uint256 orderId,
        uint256 tokenAmount
    ) external payable nonReentrant {
        _validateTokenAmount(tokenAmount);
        _validateEthPayment(tokenAmount);
        _validateOrderId(orderId);

        Order storage order = orders[orderId];

        _validateOrderTokenAmount(order, tokenAmount);

        order.numberOfTokens -= tokenAmount;
        reservedTokens -= tokenAmount;

        if (order.numberOfTokens == 0) {
            order.isActive = false;
        }

        address seller = order.seller;

        anviToken.safeTransfer(msg.sender, tokenAmount);

        (bool success, ) = payable(seller).call{value: msg.value}("");

        if (!success) {
            revert EthTransferFailed();
        }
    }

    // Read Individual Order

    function getOrder(uint256 orderId) external view returns (Order memory) {
        if (orderId >= nextOrderId) {
            revert InvalidOrderId(orderId);
        }

        return orders[orderId];
    }


    // Read Marketplace Details

    function getMarketplaceBalance()
        external
        view
        returns (
            uint256 totalBalance,
            uint256 availableBalance,
            uint256 reservedBalance
        )
    {
        totalBalance = anviToken.balanceOf(address(this));
        reservedBalance = reservedTokens;
        availableBalance = totalBalance - reservedBalance;
    }

    // Get Next Order ID

    function getNextOrderId() external view returns (uint256) {
        return nextOrderId;
    }
    function cancelSellOrder(uint256 orderId) external nonReentrant {
        _validateOrderId(orderId);

        Order storage order = orders[orderId];

        if (order.seller != msg.sender) {
            revert UnauthorizedOrderCancellation();
        }

        uint256 tokenAmount = order.numberOfTokens;

        order.numberOfTokens = 0;
        order.isActive = false;

        reservedTokens -= tokenAmount;

        anviToken.safeTransfer(msg.sender, tokenAmount);
    }
    function getCreatedOrderById(
        uint256 orderId
    ) external view returns (Order memory) {
        if (orderId >= nextOrderId) {
            revert InvalidOrderId(orderId);
        }

        return orders[orderId];
    }
    function getAllOrders() external view returns (Order[] memory) {
        Order[] memory allOrders = new Order[](nextOrderId);

        for (uint256 i = 0; i < nextOrderId; i++) {
            allOrders[i] = orders[i];
        }

        return allOrders;
    }
}
