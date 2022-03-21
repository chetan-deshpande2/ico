//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract TokenSale is Ownable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    bool public paused;

    address public admin;

    uint256 public price = 1150000;
    uint256 public totalTokenSold;
    uint256 private totalTokens = 30000000 ether;
    uint256 initialSaleQty = 30000000 ether;
    uint256 seedSaleQty = 50000000 ether;
    uint256 RemaingSaleQty = 20000000 ether;

    uint256 public initialSalePrice = 1150000;
    uint256 public seedSalePrice = 5000000;
    uint256 public finalSalePrince = 6000000;
    uint256 public priceofETH = 250000000000;

    enum Stages {
        initialSale,
        seedSale,
        RemaingSale
    }

    Stages public stage = Stages.initialSale;

    IERC20 public token;

    event TokenPurchasedEvent(
        address _purchasingAccount,
        uint256 indexed _tokensPurchase,
        uint256 indexed _amountPaid
    );
    event PriceTracker(uint256 price);

    modifier isNotPaused() {
        require(paused == false, "contract is paused");
        _;
    }

    constructor(address _admin, address _token) {
        admin = _admin;
        token = IERC20(_token);
    }

    // get amount to be paid to buy _amount tokens
    function amountNeedsToBePaid(uint256 _amount)
        public
        view
        returns (uint256)
    {
        uint256 res = priceofETH;
        uint256 amount = (_amount * price) / res;
        return amount;
    }

    function getCorrespondingTokens(uint256 _amount)
        public
        view
        returns (uint256)
    {
        uint256 currPrice = priceofETH;
        uint256 recievingTokens = (_amount * (currPrice / price));
        return recievingTokens;
    }

    /* SETTERS */

    // this will buy tokens equal to amount entered
    function buyTokens(uint256 _amount) public payable isNotPaused {
        uint256 recievingAmount;
        uint256 amountToPay;

        amountToPay = amountNeedsToBePaid(_amount);
        require(amountToPay <= msg.value, "insufficient amount");
        if (msg.value > amountToPay) {
            payable(msg.sender).transfer(msg.value - amountToPay);
        }
        payable(admin).transfer(amountToPay);
        if (totalTokens == 0) {
            setTokenStage();
        }
        recievingAmount = _amount;
        totalTokenSold = totalTokenSold + recievingAmount;

        token.safeTransfer(msg.sender, recievingAmount);
        emit TokenPurchasedEvent(msg.sender, recievingAmount, amountToPay);
    }

    function setTokenStage() internal {
        if (stage == Stages.initialSale && totalTokens == 0) {
            stage = Stages.seedSale;
            price = seedSalePrice;
            totalTokens = seedSaleQty;
        } else if (stage == Stages.seedSale && totalTokens == 0) {
            stage = Stages.RemaingSale;
            price = finalSalePrince;
            totalTokens = RemaingSaleQty;
        }
    }
}
