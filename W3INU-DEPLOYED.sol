// SPDX-License-Identifier: MIT

/**
╭╮╭╮╭┳━━━╮╭━━┳━╮╱╭┳╮╱╭╮
┃┃┃┃┃┃╭━╮┃╰┫┣┫┃╰╮┃┃┃╱┃┃
┃┃┃┃┃┣╯╭╯┃╱┃┃┃╭╮╰╯┃┃╱┃┃
┃╰╯╰╯┣╮╰╮┃╱┃┃┃┃╰╮┃┃┃╱┃┃
╰╮╭╮╭┫╰━╯┃╭┫┣┫┃╱┃┃┃╰━╯┃
W3INU: W3INU.COM
-You buy on BSC, we farm on multiple chains and return the profits to W3INU holders.

Tokenomics:
10% of each buy goes to existing holders.
10% of each sell goes into multi-chain farming and marketing to increase the treasury and buy back of W3INU tokens.

Website:
https://w3inu.com/

*/

pragma solidity ^0.6.2;

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;

        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory){
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return
        functionCallWithValue(
            target,
            data,
            value,
            "Address: low-level call with value failed"
        );
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: weiValue}(
            data
        );
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IPancakeswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IPancakeswapV2Pair {
    function sync() external;
}

interface IPancakeswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
    external
    returns (
        uint256 amountA,
        uint256 amountB,
        uint256 liquidity
    );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
    external
    payable
    returns (
        uint256 amountToken,
        uint256 amountETH,
        uint256 liquidity
    );
}

interface IPancakeswapV2Router02 is IPancakeswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;
}

contract W3INU is Context, IERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    string private _name = "W3INU (W3INU.COM)";
    string private _symbol = "W3INU";
    uint8 private _decimals = 18;

    mapping(address => uint256) internal _reflectionBalance;
    mapping(address => uint256) internal _tokenBalance;
    mapping(address => mapping(address => uint256)) internal _allowances;

    uint256 private constant MAX = ~uint256(0);
    uint256 internal _tokenTotal = 1000000000000 * 10**18;
    uint256 internal _reflectionTotal = (MAX - (MAX % _tokenTotal));

    mapping(address => bool) public _isExcludedFromFee;

    mapping(address => bool) internal _isExcludedFromReward;
    address[] internal _excludedFromReward;

    uint256 public _feeDecimal = 2;

    // index 0 = buy fee, index 1 = sell fee, index 2 = p2p fee
    uint256[] public _transferFee;
    uint256[] public _marketingFee;
    uint256[] public _farmAndBuybackFee;

    uint256 internal _feeTotal;
    uint256 internal _farmAndBuybackFeeCollected;
    uint256 internal _marketingFeeCollected;

    bool public isFeeActive = true;
    bool public swapEnabled = true;
    bool private inSwap;

    uint256 public maxTxAmount = 0;
    uint256 public minTokensBeforeSwap = 500000000 * 10**18;

    address public farmAndBuybackWallet = 0xf2c38e8461c88F5BCD9064978fFAedeE9cf30B37;
    address public marketingWallet = 0xA27645C48D6E8E1ac9380D8deaa24A2c75B0Ef44;
    address public devWallet = 0x7313D62C0C4B09746Ce6301FB7EF4C94AE619768;

    IPancakeswapV2Router02 public router;
    address public pair;

    event Swap(uint256 swaped, uint256 recieved);

    modifier lockTheSwap() {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor() public {
        IPancakeswapV2Router02 _PancakeswapV2Router = IPancakeswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        pair = IPancakeswapV2Factory(_PancakeswapV2Router.factory()).createPair(address(this), _PancakeswapV2Router.WETH());
        router = _PancakeswapV2Router;

        _isExcludedFromFee[_msgSender()] = true;
        _isExcludedFromFee[marketingWallet] = true;
        _isExcludedFromFee[farmAndBuybackWallet] = true;
        _isExcludedFromFee[address(this)] = true;

        excludeFromReward(address(pair));
        excludeFromReward(address(this));

        _reflectionBalance[_msgSender()] = _reflectionTotal;
        emit Transfer(address(0), _msgSender(), _tokenTotal);

        // index 0 = buy fee, index 1 = sell fee, index 2 = p2p fee
        _transferFee.push(1000);
        _transferFee.push(0);
        _transferFee.push(0);

        _marketingFee.push(0);
        _marketingFee.push(500);
        _marketingFee.push(500);

        _farmAndBuybackFee.push(0);
        _farmAndBuybackFee.push(500);
        _farmAndBuybackFee.push(500);
    }

    receive() external payable {}

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tokenTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcludedFromReward[account]) return _tokenBalance[account];
        return tokenFromReflection(_reflectionBalance[account]);
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool){
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256){
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool){
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool){
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool){
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

    function isExcludedFromReward(address account) public view returns (bool) {
        return _isExcludedFromReward[account];
    }

    function reflectionFromToken(uint256 tokenAmount) public view returns (uint256){
        require(tokenAmount <= _tokenTotal, "Amount must be less than supply");
        return tokenAmount.mul(_getReflectionRate());
    }

    function tokenFromReflection(uint256 reflectionAmount) public view returns (uint256){
        require(reflectionAmount <= _reflectionTotal, "Amount must be less than total reflections");
        uint256 currentRate = _getReflectionRate();
        return reflectionAmount.div(currentRate);
    }

    function excludeFromReward(address account) public onlyOwner {
        require(!_isExcludedFromReward[account], "Account is already excluded");
        if (_reflectionBalance[account] > 0) {
            _tokenBalance[account] = tokenFromReflection(
                _reflectionBalance[account]
            );
        }
        _isExcludedFromReward[account] = true;
        _excludedFromReward.push(account);
    }

    function includeInReward(address account) external onlyOwner {
        require(_isExcludedFromReward[account], "Account is already included");
        for (uint256 i = 0; i < _excludedFromReward.length; i++) {
            if (_excludedFromReward[i] == account) {
                _excludedFromReward[i] = _excludedFromReward[_excludedFromReward.length - 1];
                _tokenBalance[account] = 0;
                _isExcludedFromReward[account] = false;
                _excludedFromReward.pop();
                break;
            }
        }
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        if(
            !_isExcludedFromFee[sender] &&
            !_isExcludedFromFee[recipient]
        ){
            require(amount <= maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
        }

        if (swapEnabled && !inSwap && sender != pair) {
            swap();
        }

        uint256 transferAmount = amount;
        uint256 rate = _getReflectionRate();

        if (
            isFeeActive &&
            !_isExcludedFromFee[sender] &&
            !_isExcludedFromFee[recipient] &&
            !inSwap
        ) {
            transferAmount = collectFee(
                sender,
                amount,
                rate,
                recipient == pair,
                sender != pair && recipient != pair
            );
        }

        //transfer reflection
        _reflectionBalance[sender] = _reflectionBalance[sender].sub(
            amount.mul(rate)
        );
        _reflectionBalance[recipient] = _reflectionBalance[recipient].add(
            transferAmount.mul(rate)
        );

        //if any account belongs to the excludedAccount transfer token
        if (_isExcludedFromReward[sender]) {
            _tokenBalance[sender] = _tokenBalance[sender].sub(amount);
        }
        if (_isExcludedFromReward[recipient]) {
            _tokenBalance[recipient] = _tokenBalance[recipient].add(
                transferAmount
            );
        }

        emit Transfer(sender, recipient, transferAmount);
    }

    function calculateFee(uint256 feeIndex, uint256 amount) internal returns (uint256, uint256){
        uint256 taxFee = amount.mul(_transferFee[feeIndex]).div(
            10**(_feeDecimal + 2)
        );
        uint256 marketingFee = amount.mul(_farmAndBuybackFee[feeIndex]).div(
            10**(_feeDecimal + 2)
        );
        uint256 teamFee = amount.mul(_marketingFee[feeIndex]).div(
            10**(_feeDecimal + 2)
        );

        _farmAndBuybackFeeCollected = _farmAndBuybackFeeCollected.add(marketingFee);
        _marketingFeeCollected = _marketingFeeCollected.add(teamFee);
        return (taxFee, marketingFee.add(teamFee));
    }

    function collectFee(address account, uint256 amount, uint256 rate, bool sell, bool p2p) private returns (uint256) {
        uint256 transferAmount = amount;

        (uint256 taxFee, uint256 otherFee) = calculateFee(
            p2p ? 2 : sell ? 1 : 0,
            amount
        );
        if (otherFee != 0) {
            transferAmount = transferAmount.sub(otherFee);
            _reflectionBalance[address(this)] = _reflectionBalance[address(this)].add(otherFee.mul(rate));
            if (_isExcludedFromReward[address(this)]) {
                _tokenBalance[address(this)] = _tokenBalance[address(this)].add(otherFee);
            }
            emit Transfer(account, address(this), otherFee);
        }
        if (taxFee != 0) {
            transferAmount = transferAmount.sub(taxFee);
            _reflectionTotal = _reflectionTotal.sub(taxFee.mul(rate));
        }
        _feeTotal = _feeTotal.add(taxFee).add(otherFee);
        return transferAmount;
    }

    function swap() private lockTheSwap {
        uint256 totalFee = _marketingFeeCollected.add(_farmAndBuybackFeeCollected);
        uint256 totalFeeToSell = balanceOf(address(this));

        if (minTokensBeforeSwap >= totalFeeToSell) return;

        address[] memory sellPath = new address[](2);
        sellPath[0] = address(this);
        sellPath[1] = router.WETH();

        uint256 balanceBefore = address(this).balance;

        _approve(address(this), address(router), totalFeeToSell);
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            totalFeeToSell,
            0,
            sellPath,
            address(this),
            block.timestamp
        );

        uint256 amountFee = address(this).balance.sub(balanceBefore);

        uint256 amountFarmAndBuyback = amountFee.mul(_farmAndBuybackFeeCollected).div(totalFee);

        if (amountFarmAndBuyback > 0){
            payable(farmAndBuybackWallet).transfer(amountFarmAndBuyback);
        }

        uint256 amountMarketing = address(this).balance;
        uint256 amountDev = amountMarketing.div(5).mul(2);
        if (amountMarketing > 0){
            payable(marketingWallet).transfer(amountMarketing.sub(amountDev));
            payable(devWallet).transfer(address(this).balance);
        }

        _farmAndBuybackFeeCollected = 0;
        _marketingFeeCollected = 0;

        emit Swap(totalFeeToSell, amountFee);
    }

    function _getReflectionRate() private view returns (uint256) {
        uint256 reflectionSupply = _reflectionTotal;
        uint256 tokenSupply = _tokenTotal;

        for (uint256 i = 0; i < _excludedFromReward.length; i++) {
            if(
                _reflectionBalance[_excludedFromReward[i]] > reflectionSupply ||
                _tokenBalance[_excludedFromReward[i]] > tokenSupply
            ){
                return _reflectionTotal.div(_tokenTotal);
            }

            reflectionSupply = reflectionSupply.sub(
                _reflectionBalance[_excludedFromReward[i]]
            );

            tokenSupply = tokenSupply.sub(_tokenBalance[_excludedFromReward[i]]);
        }

        if (reflectionSupply < _reflectionTotal.div(_tokenTotal)){
            return _reflectionTotal.div(_tokenTotal);
        }

        return reflectionSupply.div(tokenSupply);
    }

    function setPairRouterRewardToken(address _pair, IPancakeswapV2Router02 _router) external onlyOwner {
        pair = _pair;
        router = _router;
        excludeFromReward(address(pair));
    }

    function setExcludeFromFee(address account, bool value) external onlyOwner {
        require(_isExcludedFromFee[account] != value, "Already set");
        _isExcludedFromFee[account] = value;
    }

    function setSwapEnabled(bool enabled) external onlyOwner {
        require(swapEnabled != enabled, "Already set");
        swapEnabled = enabled;
    }

    function setFeeActive(bool value) external onlyOwner{
        require(isFeeActive != value, "Already set");
        isFeeActive = value;
    }

    function setTransferFee(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
        require(buy <= 2500 && sell <= 2500 && p2p <= 2500, "Invalid fee");
        _transferFee[0] = buy;
        _transferFee[1] = sell;
        _transferFee[2] = p2p;
    }

    function setMarketingFee(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
        require(buy <= 2500 && sell <= 2500 && p2p <= 2500, "Invalid fee");
        _marketingFee[0] = buy;
        _marketingFee[1] = sell;
        _marketingFee[2] = p2p;
    }

    function setFarmAndBuybackFee(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
        require(buy <= 2500 && sell <= 2500 && p2p <= 2500, "Invalid fee");
        _farmAndBuybackFee[0] = buy;
        _farmAndBuybackFee[1] = sell;
        _farmAndBuybackFee[2] = p2p;
    }

    function setFarmAndBuybackWallet(address _address) external onlyOwner {
        farmAndBuybackWallet = _address;
    }

    function setMarketingWallet(address _address) external onlyOwner {
        marketingWallet = _address;
    }

    function setDevWallet(address _address) external onlyOwner {
        devWallet = _address;
    }

    function setMaxTxAmount(uint256 _newAmount) external onlyOwner() {
        require(_newAmount >= 1 * 10**18 , "maxTxAmount should be greater than 1 token");
        maxTxAmount = _newAmount;
    }

    function setMinTokensBeforeSwap(uint256 _amount) external onlyOwner {
        minTokensBeforeSwap = _amount;
    }

    function getStuckBNB() external onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function getStuckToken(address token) external onlyOwner {
        uint256 balance = IERC20(token).balanceOf(address(this));

        if(token == address(this)){
            uint256 totalFee = _marketingFeeCollected.add(_farmAndBuybackFeeCollected);

            require(balance > totalFee, "No stuck token");

            balance = balance.sub(totalFee);
        }

        require(IERC20(token).transfer(msg.sender, balance), "Transfer failed");
    }
}