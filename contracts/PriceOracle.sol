//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
contract PriceOracle {
    AggregatorV3Interface internal priceFeed;
    constructor() {
        priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
    }
    function setPriceFeedAddress(address contractAddress) external {
        priceFeed = AggregatorV3Interface(contractAddress);
    }
    function getLatesPrice(address contractAddress) public view returns (int) {
        (
            uint80 roundID,
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }
}