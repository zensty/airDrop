// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./token/ERC20/Ownable.sol";
import "./token/ERC20/ERC20.sol";

contract TokenAirDrop is Ownable{

    mapping (address => uint256) private _airDropBeneficiaryList;
    event AirDropBeneficiaryList(address indexed _beneficiary, uint256 _amount);
    
    ERC20 _tokenAddress;

    constructor (ERC20 tokenAddress_){
        _tokenAddress = tokenAddress_;
    }

    function setERC20Address(ERC20 tokenAddress_) external onlyOwner{
        _tokenAddress = tokenAddress_;
    }

    function dropToken(address[] memory _beneficiary, uint256 _amount) external onlyOwner {

        require(_beneficiary.length != 0);
        require(_beneficiary.length*_amount <= _tokenAddress.balanceOf(address(this)));

        for (uint256 i = 0; i < _beneficiary.length; i++) {
            address beneficiary = _beneficiary[i];

            _tokenAddress.transfer(beneficiary, _amount);
            _airDropBeneficiaryList[beneficiary] += _amount;

            emit AirDropBeneficiaryList(beneficiary, _amount);
        }

    }

    function getAirDropBeneficiaryList(address _beneficiary) external view returns (uint256){
        return _airDropBeneficiaryList[_beneficiary];
    }

    function resetAirDropBeneficiaryList(ERC20 tokenAddress_, address[] memory _beneficiary) external onlyOwner{
        
        require(_beneficiary.length != 0);
        
        _tokenAddress= tokenAddress_;

        for (uint256 i = 0; i < _beneficiary.length; i++) {
            address beneficiary = _beneficiary[i];

            _airDropBeneficiaryList[beneficiary] = 0;

            emit AirDropBeneficiaryList(beneficiary, 0);
        }

    }

}
