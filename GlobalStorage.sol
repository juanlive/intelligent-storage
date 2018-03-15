5pragma solidity ^0.4.15;


/*

Global storage for multiple users. One account per address.

- Controlled by Id (one address per id, one id per address)
- Updateable address (address can be replaced by a new one with the same permission to access data)

Details:

Data is related to a specific Id. Only one address is authorized to read and write data for each Id. 
Each address can transfer its ownership of an Id to another address.

Usage:

registerUser(_id): registers a new user. The id should be a key or string that hasn't been used by any other user. 
It will be used internally to register data, allowing to change the address in the future.

changeAddress(_address): transfers the Id associated to the current address to a new address.

getId(): retrieves the Id associated to the caller address.

setUint(_key , _data , _overwrite): stores a uint with a given key. Key may be an address or a string. It is encoded as bytes32.
_overwrite is an optional boolean. If it is specified as "true", data may overwrite any previous data. If it is not specified and 
there is already data stored for these key, it will return false with an error log.

getUint(_key): retrieves the data stored for that key.

setBytes32, setString, setAddress, getBytes32, getString, getAddress: same as setUint and getUint

*/

contract GlobalStorage {
    
    mapping (bytes32 => address) users;
    mapping (address => bytes32) ids;
    uint256 public totalUsers;

    event Error(string _string);
    event RegisteredUser(address _address , bytes32 _id);
    event ChangedAdd(bytes32 _id , address _old , address _new);


    modifier getOwner() {
        bytes32 memory _id = ids[msg.sender];
        _;
    }

    function registerUser(bytes32 _id) returns(bool) {
        if ( users[_id] > 0x0 ) {
            Error("User already exists");
            return false;
        }
        if (_id == 0x0) {
            Error("Invalid id");
            return false;
        }
        users[_id] = msg.sender;
        ids[msg.sender] = _id;
        totalUsers = totalUsers + 1;
        RegisteredUser(msg.sender , _id);
        return true;
    }
    
    function changeAddress(address _newAddress) returns(bool) {
        if ( ids[_newAddress] != 0x0 ) {
            Error("New address already exists");
            return false;
        }
        bytes32 memory _id = ids[msg.sender];
        users[_id] = _newAddress;
        ids[msg.sender] = 0x0;
        ids[_newAddress] = _id;
        ChangedAdd(_id , msg.sender , _newAddress);
        return true;
    }
    
    function getId() constant returns(bytes32 _id) {
        return (ids[msg.sender]);
    }
    
    
    mapping(bytes32 => mapping(bytes32 => uint256)) dataUint;
    mapping(bytes32 => mapping(bytes32 => bytes32)) dataBytes32;
    mapping(bytes32 => mapping(bytes32 => string)) dataString;
    mapping(bytes32 => mapping(bytes32 => address)) dataAddress; 

   // Uint type

    function setUint(bytes32 _id , bytes32 _key , uint256 _data , bool _overwrite) getOwner returns(bool) {
        if ( _overwrite || dataUint[_id][_key] == 0 ) {
            dataUint[_id][_key] = _data;
            return true;
        } else {
            Error("Data exists");
            return false;
        }
    }

    function getUint(bytes32 _id , bytes32 _key) onlyOwner(_id) getOwner constant returns(uint _data) {
        return dataUint[_id][_key];
    }


    // String type

    function setString(bytes32 _id , bytes32 _key , string _data , bool _overwrite) getOwner returns(bool) {
        if ( _overwrite || bytes(dataString[_id][_key]).length == 0 ) {
            dataString[_id][_key] = _data;
            return true;
        } else {
            Error("Data exists");
            return false;
        }
    }

    function getString(bytes32 _id , bytes32 _key) getOwner constant returns(string _data) {
        return dataString[_id][_key];
    }

    // Address type

    function setAddress(bytes32 _id , bytes32 _key , address _data , bool _overwrite) getOwner returns(bool) {
        if ( _overwrite || dataAddress[_id][_key] == 0x0 ) {
            dataAddress[_id][_key] = _data;
            return true;
        } else {
            Error("Data exists");
            return false;
        }
    }

    function getAddress(bytes32 _id , bytes32 _key) getOwner constant returns(address _data) {
        return dataAddress[_id][_key];
    }

    // Bytes32 type
    
    function setBytes32(bytes32 _id , bytes32 _key , bytes32 _data , bool _overwrite) getOwner returns(bool) {
        if ( _overwrite || dataBytes32[_id][_key] == 0x0 ) {
            dataBytes32[_id][_key] = _data;
            return true;
        } else {
            Error("Data exists");
            return false;
        }
    }

    function getBytes32(bytes32 _id , bytes32 _key) getOwner constant returns(bytes32 _data) {
        return dataBytes32[_id][_key];
    }

}