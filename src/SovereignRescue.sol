// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SovereignRescue {
    address public immutable safeExit;
    error TransferFailed();

    constructor(address _safeExit) {
        safeExit = _safeExit;
    }

    receive() external payable {}

    function panic(address[] calldata tokens) external {
        uint256 ethBalance = address(this).balance;
        if (ethBalance > 0) {
            (bool success, ) = safeExit.call{value: ethBalance}("");
            if (!success) revert TransferFailed();
        }

        for (uint256 i = 0; i < tokens.length; i++) {
            address token = tokens[i];
            (bool success, bytes memory data) = token.call(
                abi.encodeWithSignature("balanceOf(address)", address(this))
            );
            if (success && data.length >= 32) {
                uint256 bal = abi.decode(data, (uint256));
                if (bal > 0) {
                    token.call(abi.encodeWithSignature("transfer(address,uint256)", safeExit, bal));
                }
            }
        }
    }
}
