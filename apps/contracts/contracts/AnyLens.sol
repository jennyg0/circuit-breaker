//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@semaphore-protocol/contracts/interfaces/ISemaphore.sol";

contract AnyLens {
    ISemaphore public semaphore;

    uint256 public groupId;

    constructor(address semaphoreAddress, uint256 _groupId) {
        semaphore = ISemaphore(semaphoreAddress);
        groupId = _groupId;

        semaphore.createGroup(groupId, 20, address(this));
    }

    function joinGroup(uint256 identityCommitment) external {
        semaphore.addMember(groupId, identityCommitment);
    }

    function post(
        uint256 did,
        uint256 merkleTreeRoot,
        uint256 nullifierHash,
        uint256[8] calldata proof
    ) external {
        semaphore.verifyProof(
            groupId,
            merkleTreeRoot,
            did,
            nullifierHash,
            groupId,
            proof
        );
        //TODO:@jen post to lens after proof verification
    }
}
