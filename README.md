# intelligent-storage

Intelligent Storage

Intelligent Storage offers an external memory system that can be used by any ethereum contract. It is designed as part of a modular approach which contributes to ease upgradeability of contracts. It can be seen as a simple database.

Rinkeby: 0xb94cde73d07e0fcd7768cd0c7a8fb2afb403327a
Main network: 
ABI at the end of the document


Characteristics

- Data is related to a specific Id. 
- Only one address is authorized to write data for each Id. 
- A single address can manage multiple Ids.
- Each address can transfer its ownership of an Id to another address.
- Requires one payment to register, then you can use it for free while the ethereum network be alive (only paying the ethereum fee per transaction).


Usage

Admin functions

registerUser(bytes32 _id): registers a new Id to the caller address.

_id can be any bytes32 value. You can create it from a string with web3 or you can choose a random value. The call must be accompanied with the payment, which now consist in a promotional price of 0.005 ethers. You can retrieve the value at any time with the getter regPrice()

If the _id already existed, the payment will be returned to the caller and an event will be created with the text “ID already exists”.

_id will be used to identify your data, and will be related to the caller address, so it will be the only one authorized to write data for that _id. Address can be replaced at any time.

changeAddress(bytes32 _id , address _newAddress): transfers the ownership of the _id to a new address.

The call should be made from the address that has the actual ownership of the _id. It is adviceable that you had a function in your contract that call to this function, so once you deploy a new version of your contract, you can call this function from the old one, for the new contract be able to manage the data.

checkId(bytes32 _id): retrieves the address that has the ownership of a given _id.


Data functions

setUint(_id , _key , _data , _overwrite): stores a uint.

_id is your _id. It should be any _id registered to the caller address.
_key is a bytes32 value that represent the name of the key for your data. It can be converted from a string with web3, or it can be an address or any bytes32 value. You can create as many keys for your _id as you need.
_data is the data to store. In this case, it should be a uint.
_overwrite is an optional boolean. If it is specified as "true", data may overwrite any previous data. If it is not specified and there is already data stored for these key, the function will return false with an error log.

Example: Assuming you use the Id 0x12345 to store balances for your users and you need to replace the balance for the address 0x88888888 with a value of 4000, the function should be: setUint(0x12345 , 0x88888888 , 4000 , true). Only the address which registered the _id 0x12345 will be able to set the value.


getUint(_id , _key): retrieves the data stored for that key.

From the previous example, if you want to retrieve the balance of your user 0x88888888, the function should be: getuint(0x12345 , 0x88888888); and it should return the value 4000.


setBytes32, setString, setAddress / getBytes32, getString, getAddress: same as setUint and getUint. In each case, the parameter _data should be a bytes32, a string or an address.





ABI

[{"constant":true,"inputs":[{"name":"_id","type":"bytes32"}],"name":"checkId","outputs":[{"name":"_address","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"bytes32"},{"name":"_key","type":"bytes32"},{"name":"_data","type":"string"},{"name":"_overwrite","type":"bool"}],"name":"setString","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"regPrice","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"bytes32"},{"name":"_newAddress","type":"address"}],"name":"changeAddress","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"bytes32"}],"name":"registerUser","outputs":[{"name":"","type":"bool"}],"payable":true,"stateMutability":"payable","type":"function"},{"constant":true,"inputs":[{"name":"_id","type":"bytes32"},{"name":"_key","type":"bytes32"}],"name":"getString","outputs":[{"name":"_data","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_id","type":"bytes32"},{"name":"_key","type":"bytes32"}],"name":"getBytes32","outputs":[{"name":"_data","type":"bytes32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"bytes32"},{"name":"_key","type":"bytes32"},{"name":"_data","type":"bytes32"},{"name":"_overwrite","type":"bool"}],"name":"setBytes32","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_id","type":"bytes32"},{"name":"_key","type":"bytes32"}],"name":"getUint","outputs":[{"name":"_data","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_newAdmin","type":"address"}],"name":"changeAdmin","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_newPrice","type":"uint256"}],"name":"changePrice","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalUsers","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_id","type":"bytes32"},{"name":"_key","type":"bytes32"}],"name":"getAddress","outputs":[{"name":"_data","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"totalCollected","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"bytes32"},{"name":"_key","type":"bytes32"},{"name":"_data","type":"address"},{"name":"_overwrite","type":"bool"}],"name":"setAddress","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"bytes32"},{"name":"_key","type":"bytes32"},{"name":"_data","type":"uint256"},{"name":"_overwrite","type":"bool"}],"name":"setUint","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"admin","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_string","type":"string"}],"name":"Error","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_address","type":"address"},{"indexed":false,"name":"_id","type":"bytes32"}],"name":"RegisteredUser","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_id","type":"bytes32"},{"indexed":false,"name":"_old","type":"address"},{"indexed":false,"name":"_new","type":"address"}],"name":"ChangedAdd","type":"event"}]
