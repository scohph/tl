// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import { LibMerkleProof } from "./libraries/LibMerkleProof.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "./interfaces/IERC20.sol";

error AddressCannotBeZero(address addr);
error InsufficientBalance();
error NotExpired();

contract Vesting is Ownable, ReentrancyGuard {

    uint256 constant ONE_YEAR_IN_SEC = 365 days;

    string private name_;
    bytes32 private merkleRoot;
    uint256 private createdAt;
    address private tokenAddress;

    mapping(bytes32 => uint256) public claimedAmount;

    event Transfer(address indexed from, address indexed to, uint256 value, uint256 when);
    event Withdrawal(address indexed from, address indexed to, uint256 value, uint256 when);

    constructor(
        string memory _name,
        bytes32 _merkleRoot,
        address _tokenAddress,
        address _initialOwner
    ) 
        Ownable(_initialOwner) 
    {
        name_ = _name;
        merkleRoot = _merkleRoot;
        tokenAddress = _tokenAddress;
        createdAt = block.timestamp;
    }

    function claimTokens(
        uint256 _nodeIndex, 
        uint256 _amount, 
        bytes32[] calldata _merkleProof
    ) 
        public 
        nonReentrant 
    {
        bytes32 node = keccak256(abi.encodePacked(_nodeIndex, msg.sender, _amount));
        require(LibMerkleProof.verify(_merkleProof, merkleRoot, node), "Invalid proof.");

        (
            uint256 claimableAmount
        ) = calculateClaim(_nodeIndex,_amount,msg.sender,_merkleProof);
        if(claimableAmount == 0) revert NotExpired();

        unchecked {
            claimedAmount[node] += claimableAmount;
        }

        IERC20(tokenAddress).transfer(msg.sender,claimableAmount);
        emit Transfer(address(this),msg.sender,claimableAmount,block.timestamp);
    }

    function calculateClaim(
        uint256 _nodeIndex, 
        uint256 _amount, 
        address _user, 
        bytes32[] calldata _merkleProof
    ) 
        public 
        view 
        returns(uint256) 
    {
        bytes32 node = keccak256(abi.encodePacked(_nodeIndex, _user, _amount));
        if(!LibMerkleProof.verify(_merkleProof, merkleRoot, node)){ return 0; }
        if(claimedAmount[node] == _amount){ return 0; }

        uint256 currentTimestamp = block.timestamp;
        uint256 perSecDistributeAmount = _amount / ONE_YEAR_IN_SEC;
        uint256 distributionEndTime = createdAt + ONE_YEAR_IN_SEC;
        uint256 activeTime = currentTimestamp > distributionEndTime ? ONE_YEAR_IN_SEC : currentTimestamp - createdAt;
        uint256 claimableAmount = activeTime * perSecDistributeAmount;

        unchecked {
            claimableAmount -= claimedAmount[node];
        }
        
        return claimableAmount;
    }

    function getClaimedAmount(
        uint256 _nodeIndex, 
        uint256 _amount, 
        address _user, 
        bytes32[] calldata _merkleProof
    )
        public 
        view 
        returns(uint256) 
    {
        bytes32 node = keccak256(abi.encodePacked(_nodeIndex, _user, _amount));
        if(!LibMerkleProof.verify(_merkleProof, merkleRoot, node)){ return 0; }
        return claimedAmount[node];
    }

    function getUndrawedAmount(
        uint256 _nodeIndex, 
        uint256 _amount, 
        address _user, 
        bytes32[] calldata _merkleProof
    )
        public 
        view 
        returns(uint256) 
    {
        bytes32 node = keccak256(abi.encodePacked(_nodeIndex, _user, _amount));
        if(!LibMerkleProof.verify(_merkleProof, merkleRoot, node)){ return 0; }
        if(claimedAmount[node] == _amount){ return 0; }

        return _amount - claimedAmount[node];
    }

    function withdrawToken(
        uint256 _amount,
        address _to,
        address _tokenAddress
    ) 
        external 
        onlyOwner 
    {
        if(_to == address(0)) { revert AddressCannotBeZero(_to); }
        if(_amount > IERC20(_tokenAddress).balanceOf(address(this))){ revert InsufficientBalance(); }
        IERC20(_tokenAddress).transfer(_to,_amount);
    }

    function withdrawNative(
        uint256 _amount,
        address _recipient
    ) 
        external 
        onlyOwner 
    {
        if(_recipient == address(0)) { revert AddressCannotBeZero(_recipient); }
        if(_amount > address(this).balance){ revert InsufficientBalance();}
        (bool success, ) = _recipient.call{value: _amount}(new bytes(0));
        require(success);
    }

    receive() external payable {}

}
