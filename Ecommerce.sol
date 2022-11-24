// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Ecommerce {
    struct Product {
        string title;
        string desc;
        address payable seller;
        uint256 product_id;
        uint256 price;
        address buyer;
        bool delivered;
    }
    uint256 counter = 1;
    Product[] public allProducts;

    event registeredProduct(string title, uint256 product_id, address seller);
    event boughtProduct(uint256 product_id, address buyer);
    event delivered(uint256 product_id);

    function addProducts(
        string memory _title,
        string memory _desc,
        uint256 _price
    ) public {
        require(_price > 0, "Price should be greater than zero");
        Product memory tempProduct;
        tempProduct.title = _title;
        tempProduct.desc = _desc;
        tempProduct.price = _price * 10**18;
        tempProduct.seller = payable(msg.sender);
        tempProduct.product_id = counter;
        allProducts.push(tempProduct);
        counter++;

        emit registeredProduct(_title, tempProduct.product_id, msg.sender);
    }

    function buyProducts(uint256 _product_id) public payable {
        require(
            allProducts[_product_id - 1].price == msg.value,
            "Please pay exact price"
        );
        require(
            allProducts[_product_id - 1].seller != msg.sender,
            "Seller can not be the buyer"
        );
        allProducts[_product_id - 1].buyer = msg.sender;

        emit boughtProduct(_product_id, msg.sender);
    }

    function delivery(uint256 _product_id) public {
        require(
            allProducts[_product_id - 1].buyer == msg.sender,
            "Only can buyer confirm it"
        );
        allProducts[_product_id-1].delivered = true;
        allProducts[_product_id-1].seller.transfer(
            allProducts[_product_id-1].price
        );

        emit delivered(_product_id);
    }
}
