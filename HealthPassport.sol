// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract HealthPassport {
    
    address public moderator;
    
    struct HealthAssetHolder {
        address addr;
        uint levelOneKey;
        uint levelTwoKey;
        uint levelThreeKey;
    }
    
    struct Requestor {
        address addr;
        uint MaxAccessLevel;        // the highest level a requestor can request. 
    }
    
    modifier onlyModerator { 
        require(msg.sender == moderator);
        _;
    }
}

