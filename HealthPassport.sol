// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract HealthPassport {
    
    address public moderator;
    mapping(address => uint) public balances;
    
    struct HealthAssetHolder {
        address addr;
        uint levelOneKey;
        uint levelTwoKey;
        uint levelThreeKey;
    }
    
    mapping (address => HealthAssetHolder) public healthDetails;
    mapping (address=>uint) subscription; 

    
    struct Requestor {
        address addr;
        uint accessLevel;
    }
    
    Requestor requestor;
    
    modifier onlyModerator { 
        require(msg.sender == moderator);
        _;
    }
    
    modifier onlyRequestor {
        require(msg.sender == requestor);
        _;
    }
    
    modifier maxAccessLevel(uint level)  {
      if (requestor.accessLevel >= level) {             // the highest level a requestor can request. 
         _;
      }
    }
    
    function setAccessLevel(uint level) public onlyModerator {
        requestor.accessLevel = level;
    }
    
    function register(uint status) public payable {
        /* 
            status: 0 -> default (not account)
            status: 1 -> healthAssetHolder
            status: 2 -> requestor
        */
        address user = msg.sender;
        
        if (status == 1) {
            subscription[user] = 1; 
        }
        
        if (status == 2) {
            subscription[user] = 2;
        }
     }
    
    function unregister (address payable user) onlyModerator public {
        if (moderator!= msg.sender) {
            revert();
        }
        
        subscription[user] = 0;
    }
    
    function request(address healthAssetHolder, uint levelHash, uint level) onlyRequestor public { 
        if (subscription[healthAssetHolder] != 1 || requestor[msg.sender].accessLevel < level) {
            revert();
        }
        // How to verify what level does the hash belong to?
        // How to 

      
    }
}

