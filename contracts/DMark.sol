// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.27;

contract DMark {
    address public owner;
    address public buyer;

    enum OrderStatus {
        None,
        Created,
        Pending,
        Sold
    }

    struct Asset {
        string name;
        uint16 price;
        OrderStatus status;
    }

    Asset[] public assets;
    mapping(uint256 => bool) public isSold;

    event AssetListed(string indexed name, uint16 price);
    event AssetSold(string indexed name, uint16 price, address buyer);

    constructor() {
        owner = msg.sender;
    }

    function createItem(string memory _name, uint16 _price) external {
        require(msg.sender != address(0), "Zero address is not allowed");

        Asset memory newAsset;
        newAsset.name = _name;
        newAsset.price = _price;
        newAsset.status = OrderStatus.Created;

        assets.push(newAsset);

        emit AssetListed(_name, _price);
    }

    function purchaseItem(uint8 _index) external payable {
        require(_index < assets.length, "Out of bound!");
        Asset storage asset = assets[_index];

        require(
            asset.status == OrderStatus.Created,
            "Asset is not available for sale"
        );
        require(msg.value == asset.price, "Incorrect amount sent");

        asset.status = OrderStatus.Sold;
        isSold[_index] = true;

        (bool sent, ) = owner.call{value: msg.value}("");
        require(sent, "Failed to send Ether");

        emit AssetSold(asset.name, asset.price, msg.sender);
    }
}
