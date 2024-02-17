//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@semaphore-protocol/contracts/interfaces/ISemaphore.sol";

interface ILensHub {
    function post(string memory contentURI) external;
}

contract AnyLens {
    ISemaphore public semaphore;
    ILensHub public lensHub;

    uint256 public groupId;

    constructor(address semaphoreAddress, uint256 _groupId, address _lensHubAddress) {
        semaphore = ISemaphore(semaphoreAddress);
        groupId = _groupId;
        lensHub = ILensHub(_lensHubAddress);

        semaphore.createGroup(groupId, 20, address(this));
    }

    function joinGroup(uint256 identityCommitment) external {
        semaphore.addMember(groupId, identityCommitment);
    }

    function post(
        uint256 did,
        uint256 merkleTreeRoot,
        uint256 nullifierHash,
        uint256[8] calldata proof,
        string memory contentURI
    ) external {
        semaphore.verifyProof(groupId, merkleTreeRoot, did, nullifierHash, groupId, proof);

        lensHub.post(contentURI);
    }
}
