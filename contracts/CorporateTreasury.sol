// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CorporateTreasury{
    enum Continent { 
        None,
        NorthAmerica,
        Europe,
        Asia,
        Oceania,
        SouthAmerica,
        Africa 
    }
    enum AssetClass{
        Equity,
        FixedIncome,
        Crypto,
        RealEstate
    }
    struct Investment {
        uint256 id;
        address investor;
        string assetName;
        uint256 principal;
        uint256 timestamp;
        Continent continent;
        AssetClass assetClass;
    }
    mapping(uint256 => Investment) public ledger;
    mapping(uint256 => bool) public idUsed;
    uint256 public totalInvestmentsCount;
    address public owner;

    error CorporateTreasury_NotAuthorized();
    error CorporateTreasury_InvalidAmount();
    error CorporateTreasury_SelectContinent();
    error CorporateTreasury_IDExists();
    error CorporateTreasury_InvestmentNotExist();

    event InvestmentRecorded(uint id, address investor, string assetName, uint256 principal,Continent continent);

    modifier onlyOwner() {
        // 1. The Guard Condition
        if(msg.sender != owner){
            revert CorporateTreasury_NotAuthorized();
        }
        _; 
    }

    function addInvestment(uint256 _id, string memory _assetName, Continent _continent, AssetClass _assetClass) external payable {
        if(msg.value == 0){
            revert CorporateTreasury_InvalidAmount();
        }
        if(_continent == Continent.None){
            revert CorporateTreasury_SelectContinent();
        }
        if(idUsed[_id] == true){
            revert CorporateTreasury_IDExists();
        }
        ledger[_id] = Investment({
            id: _id,
            investor: msg.sender,
            assetName: _assetName,
            principal: msg.value,
            timestamp: block.timestamp,
            continent: _continent,
            assetClass: _assetClass
        });
        idUsed[_id] = true;

        totalInvestmentsCount++;

        emit InvestmentRecorded(_id, msg.sender, _assetName, msg.value, _continent);
    }

    function getDaysUnderManagement(uint256 _id) public view returns (uint256 daysUnderMgmt){
        if(idUsed[_id] == false){
            revert CorporateTreasury_InvestmentNotExist();
        }
        daysUnderMgmt =
            (block.timestamp - ledger[_id].timestamp) /
            1 days;
        return daysUnderMgmt;
    }
}
