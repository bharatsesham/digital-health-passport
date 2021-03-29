// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract HealthPassort{
    
    address moderator;

    struct HealthAssetHolder {
        string name;
        uint loinc;
        bytes32 result;
        uint levelOneKey;
        uint levelTwoKey;
        uint levelThreeKey;
        uint balance;
    }
    
    struct Requestor {
        string name;
        uint accessLevel;
        uint balance;
    }
    
    mapping (address => HealthAssetHolder) healthDetails;
    mapping (address =>  Requestor) requestorDetails;

        
    /* 
        subscription: 0 -> default (not account)
        subscription: 1 -> healthAssetHolder
        subscription: 2 -> requestor
        subscription: 3 -> moderator
    */
    mapping (address=>uint) public subscription; 
    
    modifier onlyModerator { 
        require(msg.sender == moderator);
        _;
    }
    
    modifier onlyRequestor { 
        require(subscription[msg.sender] == 2);
        _;
    }
    
    constructor () payable  {
        moderator = msg.sender;
        subscription[msg.sender] = 3;           // Registered as Moderator
    }
    
    // User can register their health passport using this function
    function register (string memory _name) public payable {
        address assetHolder = msg.sender; 
        healthDetails[msg.sender].name = _name;
        require(subscription[assetHolder] == 0, "Already registered");
        subscription[assetHolder] = 1; 
        healthDetails[msg.sender].balance = msg.value;
    }
    
    // Only Moderator can enroll the requestor with a certain accessLevel permission
    function enroll (address requestor, uint _accessLevel, string memory _name) public onlyModerator payable {
        require(subscription[requestor] == 0, "Already registered");
        subscription[requestor] = 2;
        requestorDetails[requestor].name = _name;
        requestorDetails[requestor].accessLevel = _accessLevel;
        requestorDetails[requestor].balance = msg.value;
    }
    
    // Only Moderator can unregister. 
    function unregister (address user) onlyModerator public {
        subscription[user] = 0;
    }
    
    // Requestor can use this function to request health details of the asset holder. 
    function request(address healthAssetHolder, uint levelHash, uint level) onlyRequestor public { 
        if (subscription[healthAssetHolder] != 1 || requestorDetails[msg.sender].accessLevel < level) {
            revert();
        }
        // Share the details. 
    }
}