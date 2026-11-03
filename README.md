# 🪙 AnviToken Marketplace

A Solidity-based ERC20 token ecosystem featuring **ANVI Token**, a decentralized token marketplace, and corporate treasury management. Built using Ethereum smart contracts and OpenZeppelin libraries.

The project enables users to purchase ANVI tokens directly from the marketplace, create sell orders, trade tokens with other users, and manage their orders securely through blockchain transactions.

---

## 🚀 Features

### 1. ANVI Token (`anvi_token.sol`)
- ERC20 token implementation.
- Blockchain-based token ownership and transfers.
- Compatible with standard ERC20 wallets and applications.

### 2. Token Marketplace (`Token_Market_Place.sol`)
A smart contract that facilitates ANVI token trading.

**Direct Token Purchasing**
- Buy tokens directly from the marketplace.
- ETH-based payments.
- Automatic token transfers using SafeERC20.

**Sell Orders**
- Create sell orders by depositing ANVI tokens.
- Check token balances and allowances before creating orders.
- Reserve tokens associated with active orders.

**Peer-to-Peer Trading**
- Purchase tokens from existing sell orders.
- Partial order purchases supported.
- ETH payments are transferred to the respective seller.
- Orders are automatically marked inactive when fully purchased.

**Order Management**
- Cancel active sell orders.
- Retrieve individual orders by ID.
- Retrieve all created orders.
- Track active and completed orders.

**Security**
- OpenZeppelin SafeERC20.
- ReentrancyGuard.
- Custom Solidity errors.
- Balance, allowance, and order validation.
- Reserved-token accounting.

### 3. Corporate Treasury (`CorporateTreasury.sol`)
An additional smart contract included in the project for corporate treasury functionality.

---

## 🏗️ Project Architecture

```text
AnviToken-Marketplace/
│
├── contracts/
│   ├── anvi_token.sol
│   ├── Token_Market_Place.sol
│   ├── CorporateTreasury.sol
│   │
│   └── types/
│       └── Trade.sol
│
├── scripts/
│
├── tests/
│
├── README.md
├── remix.config.json
└── .prettierrc.json
```

---

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Solidity | Smart contract development |
| Ethereum | Blockchain infrastructure |
| ERC20 | Token standard |
| OpenZeppelin | Secure contract libraries |
| Remix IDE | Development and deployment |
| JavaScript | Scripting and testing |
| Git & GitHub | Version control |

---

## ⚙️ Smart Contract Functions

### Token Marketplace

| Function | Description |
|---|---|
| `buyTokens()` | Purchase tokens directly from the marketplace |
| `createSellOrder()` | Create a new token sell order |
| `buyTokensFromOrder()` | Purchase tokens from an existing order |
| `cancelSellOrder()` | Cancel an active sell order |
| `getCreatedOrderById()` | Retrieve an order using its ID |
| `getAllOrders()` | Retrieve all created orders |
| `getMarketplaceBalance()` | View total, available, and reserved tokens |
| `getNextOrderId()` | Retrieve the next order ID |

---

## 📦 Installation and Setup

### Prerequisites

- MetaMask or another EVM-compatible wallet.
- Remix IDE.
- Basic knowledge of Solidity and Ethereum.
- ETH for deployment and transaction gas fees.

### Step 1: Open Remix IDE

Visit:

https://remix.ethereum.org/

### Step 2: Import the Project

Create the following directories and files inside Remix:

```text
contracts/
├── anvi_token.sol
├── Token_Market_Place.sol
├── CorporateTreasury.sol
└── types/
    └── Trade.sol
```

Copy the corresponding Solidity source code into each file.

### Step 3: Install Dependencies

The marketplace uses OpenZeppelin contracts.

```bash
npm install @openzeppelin/contracts
```

### Step 4: Compile Contracts

1. Open the Solidity Compiler in Remix.
2. Select Solidity version `0.8.20`.
3. Compile `anvi_token.sol`.
4. Compile `Token_Market_Place.sol`.
5. Compile `CorporateTreasury.sol` when needed.

### Step 5: Deploy Contracts

1. Deploy `AnviToken.sol` first.
2. Copy the deployed ANVI token contract address.
3. Deploy `Token_Market_Place.sol`.
4. Pass the ANVI token contract address into the marketplace constructor.
5. Confirm deployment through your connected wallet.

---

## 🔄 How to Use the Marketplace

### Creating a Sell Order

1. Deploy the ANVI token and marketplace contracts.
2. Obtain ANVI tokens in your wallet.
3. Call `approve()` on the ANVI token contract.
4. Set the marketplace contract as the spender.
5. Approve the required token amount.
6. Call `createSellOrder()` on the marketplace.
7. Your tokens will be transferred to the marketplace and reserved for your order.

### Purchasing Tokens From an Order

1. Retrieve available orders using `getAllOrders()`.
2. Select an active order.
3. Call `buyTokensFromOrder(orderId, tokenAmount)`.
4. Send the exact required ETH payment.
5. The purchased tokens are transferred to your wallet.
6. The seller receives the ETH payment.

### Cancelling an Order

1. Retrieve your order ID.
2. Call `cancelSellOrder(orderId)`.
3. The order is marked inactive.
4. The reserved tokens are returned to your wallet.

---

## 🔐 Security Considerations

The marketplace incorporates several security mechanisms:

- **SafeERC20:** Handles ERC20 token transfers safely.
- **ReentrancyGuard:** Protects external transaction functions against reentrancy.
- **Custom Errors:** Provides efficient and descriptive transaction failure handling.
- **Access Validation:** Ensures only the original seller can cancel their order.
- **Allowance Validation:** Checks token approval before transferring tokens.
- **Reserved Token Accounting:** Prevents direct marketplace purchases from consuming tokens reserved for sell orders.

**Important:** This project has not been independently audited. Test thoroughly on a testnet before considering mainnet deployment.

---

## 🗺️ Future Improvements

- Custom pricing for individual sell orders.
- Marketplace events for tracking transactions.
- Pagination for retrieving large order histories.
- Frontend integration using React and ethers.js.
- Automated smart contract testing.
- Deployment scripts and verification.
- Marketplace ETH withdrawal functionality.

---

## 👨‍💻 Author

**Vansh Khubchandani**

- GitHub: https://github.com/Vanshdev21
- Medium: https://medium.com/@vanshkhubchandani21

---

## 📜 License

This project is licensed under the GNU General Public License v3.0 (GPL-3.0).

See the [LICENSE](https://www.gnu.org/licenses/gpl-3.0.html) for details.

---

⭐ If you find this project interesting, consider giving the repository a star!

**Built with Solidity and OpenZeppelin.**
