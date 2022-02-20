//SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestToken is ERC20("Test Token", "TST") {
	constructor() {
		_mint(msg.sender, 1_000_000 ether);
	}
}
