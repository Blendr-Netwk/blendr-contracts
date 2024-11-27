// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";


contract RewardDistributor {
    address public serverAddress;
    address public rewardAddress;
    mapping(address => uint256) public userNonce;
    mapping(address => uint256) public rewardsClaimed;

    uint256 public claimTimeLimit = 3600;

    event RewardClaimed(address indexed user, uint256 amount);

    constructor(address _serverAddress,address _rewardAddress) {
        serverAddress = _serverAddress;
        rewardAddress = _rewardAddress;
    }

    function claimReward(
        uint256 amount,
        uint256 nonce,
        uint256 timestamp,
        bytes memory signature
    ) public {
        require(block.timestamp - timestamp <= claimTimeLimit, "Signature expired");

        require(nonce == userNonce[msg.sender], "Invalid nonce");

        bytes32 message = keccak256(abi.encodePacked(msg.sender, amount, nonce, timestamp));
        bytes32 messageHash = prefixed(message);

        require(recoverSigner(messageHash, signature) == serverAddress, "Invalid signature");

        rewardsClaimed[msg.sender] += amount;

        userNonce[msg.sender]++;

        require(IERC20(rewardAddress).transfer(msg.sender, amount),"Failed to transfer reward");

        emit RewardClaimed(msg.sender, amount);
    }

    function recoverSigner(bytes32 message, bytes memory sig) internal pure returns (address) {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);
        return ecrecover(message, v, r, s);
    }

    function splitSignature(bytes memory sig) internal pure returns (uint8, bytes32, bytes32) {
        require(sig.length == 65, "Invalid signature length");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }

    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}