//SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IWETH {
	function deposit() external payable;
	function withdraw(uint256 wad) external;
}

contract Bank is Ownable {
	using SafeERC20 for IERC20;

	event Deposit(address indexed user, address indexed token, uint256 amount);
	event Withdraw(address indexed user, address indexed token, uint256 amount);
	event SetFee(uint256 fee);

	// user => token => amount
	mapping (address => mapping (address => uint256)) public balance;

	uint256 public fee; // 100% => 10000, 1% => 100, 0.5% => 50, 0.01% => 1
	uint256 public constant FEE_DEVIDER = 10000;

	IWETH public constant WETH = IWETH(0x7539595ebdA66096e8913a24Cc3C8c0ba1Ec79a0);

	function deposit(address token, uint256 amount) external {
		require(token != address(0), "!token");
		uint256 beforeBalance = IERC20(token).balanceOf(address(this));
		IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
		uint256 afterBalance = IERC20(token).balanceOf(address(this));
		require(afterBalance == beforeBalance + amount, "!balance");

		_deposit(msg.sender, token, amount);
	}

	function depositEther() external payable {
		_deposit(msg.sender, address(WETH), msg.value);
		WETH.deposit{value: msg.value}();
	}

	function _deposit(address user, address token, uint256 amount) private {
		balance[user][token] += amount;
		emit Deposit(user, token, amount);
	}

	function withdraw(address token, uint256 amount) external {
		_withdraw(msg.sender, token, amount);

		uint256 feeAmount = (amount * fee) / FEE_DEVIDER;
		IERC20(token).safeTransfer(msg.sender, amount - feeAmount);
		if (feeAmount > 0) {
			IERC20(token).safeTransfer(owner(), feeAmount);
		}
	}

	function withdrawEther(uint256 amount) external {
		_withdraw(msg.sender, address(WETH), amount);

		WETH.withdraw(amount);

		uint256 feeAmount = (amount * fee) / FEE_DEVIDER;
		payable(msg.sender).transfer(amount - feeAmount);
		if (feeAmount > 0) {
			payable(owner()).transfer(feeAmount);
		}
	}

	function _withdraw(address user, address token, uint256 amount) private {
		require(token != address(0), "!token");
		require(amount > 0, "!amount");
		require(balance[user][token] >= amount, "!balance");

		balance[user][token] -= amount;
		emit Withdraw(user, token, amount);
	}

	function setFee(uint256 fee_) external onlyOwner {
		emit SetFee(fee_);
		fee = fee_;
		require(fee <= 500, "!fee");
	}

	receive() external payable {
		require(msg.sender == address(WETH), "!WETH");
	}
}
