pragma solidity ^0.4.15;


/*

Global storage for multiple users. Multiple accounts per address.

- Controlled by Id (many ids per address)
- Updateable address (address can be replaced by a new one with the same permission to access data)


Details:

Data is related to a specific Id. Only one address is authorized to read and write data for each Id. 
Each address can transfer its ownership of an Id to another address.

Usage:

registerUser(_id): registers a new Id to the caller address.

changeAddress(_id , _address): transfers the Id of the current address to a new one.

checkId(_id): get the address associated with the specified Id.

setUint(_id , _key , _data , _overwrite): stores a uint with a given key. Key may be an address or a string. It is encoded as bytes32. 
_overwrite is an optional boolean. If it is specified as "true", data may overwrite any previous data. If it is not specified and 
there is already data stored for these key, it will return false with an error log.

getUint(_id , _key): retrieves the data stored for that key.

setBytes32, setString, setAddress, getBytes32, getString, getAddress: same as setUint and getUint

*/

contract GlobalStorageMultiId {
    
    mapping (bytes32 => address) users;
    // mapping (address => bytes32) ids;
    uint256 public totalUsers;

    event Error(string _string);
    event RegisteredUser(address _address , bytes32 _id);
    event ChangedAdd(bytes32 _id , address _old , address _new);


    modifier onlyOwner(bytes32 _id) {
        if ( users[_id] != msg.sender ) {
            revert();
        }
        _;
    }

    function registerUser(bytes32 _id) returns(bool) {
        if ( users[_id] != 0x0 ) {
            Error("User already exists");
            return false;
        }
        if (_id == 0x0) {
            Error("Invalid Id");
            return false;
        }
        users[_id] = msg.sender;
        // ids[msg.sender] = _id;
        totalUsers = totalUsers + 1;
        RegisteredUser(msg.sender , _id);
        return true;
    }
    
    function changeAddress(bytes32 _id , address _newAddress) onlyOwner(_id) returns(bool) {
        users[_id] = _newAddress;
        ChangedAdd(_id , msg.sender , _newAddress);
        return true;
    }
    
    function checkId(bytes32 _id) constant returns(address _address) {
        return users[_id];
    }
    
    
    mapping(bytes32 => mapping(bytes32 => uint256)) dataUint;
    mapping(bytes32 => mapping(bytes32 => bytes32)) dataBytes32;
    mapping(bytes32 => mapping(bytes32 => string)) dataString;
    mapping(bytes32 => mapping(bytes32 => address)) dataAddress; 


    // Uint type

    function setUint(bytes32 _id , bytes32 _key , uint256 _data , bool _overwrite) onlyOwner(_id) returns(bool) {
        if ( _overwrite || dataUint[_id][_key] == 0 ) {
            dataUint[_id][_key] = _data;
            return true;
        } else {
            Error("Data exists");
            return false;
        }
    }

    function getUint(bytes32 _id , bytes32 _key) constant returns(uint _data) {
        return dataUint[_id][_key];
    }


    // String type

    function setString(bytes32 _id , bytes32 _key , string _data , bool _overwrite) onlyOwner(_id) returns(bool) {
        if ( _overwrite || bytes(dataString[_id][_key]).length == 0 ) {
            dataString[_id][_key] = _data;
            return true;
        } else {
            Error("Data exists");
            return false;
        }
    }

    function getString(bytes32 _id , bytes32 _key) constant returns(string _data) {
        return dataString[_id][_key];
    }

    // Address type

    function setAddress(bytes32 _id , bytes32 _key , address _data , bool _overwrite) onlyOwner(_id) returns(bool) {
        if ( _overwrite || dataAddress[_id][_key] == 0x0 ) {
            dataAddress[_id][_key] = _data;
            return true;
        } else {
            Error("Data exists");
            return false;
        }
    }

    function getAddress(bytes32 _id , bytes32 _key) constant returns(address _data) {
        return dataAddress[_id][_key];
    }

    // Bytes32 type
    
    function setBytes32(bytes32 _id , bytes32 _key , bytes32 _data , bool _overwrite) onlyOwner(_id) returns(bool) {
        if ( _overwrite || dataBytes32[_id][_key] == 0x0 ) {
            dataBytes32[_id][_key] = _data;
            return true;
        } else {
            Error("Data exists");
            return false;
        }
    }

    function getBytes32(bytes32 _id , bytes32 _key) constant returns(bytes32 _data) {
        return dataBytes32[_id][_key];
    }
}