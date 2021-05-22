pragma solidity ^0.4.25;

//---0xBD162043881773c24C974D881D7D7A36aD03d8c4

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a,"invalid operation");
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a,"invalid operation");
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b,"invalid operation");
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0,"invalid operation");
        c = a / b;
    }
}

interface token {
	function transferFrom(address _from, address _to, uint256 _value) external;
    function transfer(address _to, uint256 _value) external;
    function balanceOf(address _owner) external returns(uint256);
}

contract FMUSK{
    token private tokenErc20;

    uint256 private supportercount = 0; 
    address[] private alladd; 
    uint256[] private allvalue;
    mapping(address=>uint256) private supporter;

    address private owner; 
    uint256 private total = 0; 
    uint256 private price = 20000; 
    uint256 private precount = 10000;
    uint256 private presetaddliquiditystartsupportercount = 10000000;
    uint256 private timelock = 10000000;
    bool firstairdropped = false;
    bool secondairdropped = false;
    bool thirdairdropped = false;
    

    event FundTransfer(address investor, uint256 amount,uint256 ticket, bool isContribution); 

    constructor(uint256 startcount) public{
        owner = msg.sender;
        timelock = startcount;
        tokenErc20 = token(address(0x4a54e0c6e7c2d4341d0dF2f6e0A8c2Aab7497822)); 
    }

    function () public payable{
        uint256 a = msg.value;
        if (a > 0){
            if (a <= 10 ether){
                bool isfound = false;
                if(supporter[msg.sender]>0){
                    isfound = true;
                }
 
                price = getprice();

                if (isfound == false && price > 0){
                    uint256 thisbalance = tokenErc20.balanceOf(this);
                    uint256 ufirst = SafeMath.mul(a,price); 
                    uint256 reward =SafeMath.div(ufirst,10**18);
                    if(thisbalance >= reward){
                        total += a;
                        alladd.push(msg.sender);
                        allvalue.push(a);
                        supporter[msg.sender] = a;

                        supportercount = supportercount + 1;
                        tokenErc20.transfer(msg.sender,reward);

                        emit FundTransfer(msg.sender,msg.value,reward,true);
                    }else{
                        revert();
                    }

                }else{
                    revert();
                }
            }else{
                revert();
            }

        }else{
            if(supportercount <= 10000){
                alladd.push(msg.sender);
                allvalue.push(10);
                supporter[msg.sender] = 10;
                supportercount = supportercount + 1;
                uint256 freeairdrop = 100;
                if(supportercount <= 5000){
                    freeairdrop = 1000;
                    if(supportercount <= 1000){
                        freeairdrop = 10000;
                        if(supportercount <= 100){
                            freeairdrop = 50000;
                        }
                    }
                }
                tokenErc20.transfer(msg.sender,freeairdrop);

                emit FundTransfer(msg.sender,msg.value,freeairdrop,true);                
            }else{
                revert();
            }
        }

    }

    function donate() public payable returns(bool isok){
        uint256 a = msg.value;
        if (a > 0){
            if (a <= 10 ether){
                bool isfound = false;
                if(supporter[msg.sender]>0){
                    isfound = true;
                }
 
                price = getprice();

                if (isfound == false && price > 0){
                    uint256 thisbalance = tokenErc20.balanceOf(this);
                    uint256 ufirst = SafeMath.mul(a,price); 
                    uint256 backci =SafeMath.div(ufirst,10**18);
                    if(thisbalance >= backci){
                        total += a;
                        alladd.push(msg.sender);
                        allvalue.push(a);
                        supporter[msg.sender] = a;

                        supportercount = supportercount + 1;
                        tokenErc20.transfer(msg.sender,backci);

                        emit FundTransfer(msg.sender,msg.value,backci,true);
                    }else{
                        revert();
                    }

                }else{
                    revert();
                }
            }else{
                revert();
            }

        }else{
            if(supportercount <= 10000){
                alladd.push(msg.sender);
                allvalue.push(0);
                supporter[msg.sender] = 0;
                uint256 freeairdrop = 100;
                if(supportercount <= 5000){
                    freeairdrop = 1000;
                    if(supportercount <= 1000){
                        freeairdrop = 10000;
                        if(supportercount <= 100){
                            freeairdrop = 50000;
                        }
                    }
                }
                tokenErc20.transfer(msg.sender,freeairdrop);

                emit FundTransfer(msg.sender,msg.value,freeairdrop,true);                
            }else{
                revert();
            }
        }

    }

    function getprice() public view returns(uint256 p){
        uint256 thisbalance = tokenErc20.balanceOf(this);
        uint256 curcount = precount + supportercount;
        return SafeMath.div(thisbalance, curcount); 
    }

    function airdropFirst() public payable{
        if (supportercount > 50000 && firstairdropped == false){
            uint256 airdropallamount =SafeMath.div(SafeMath.mul(address(this).balance,3),10);
            uint256 len = alladd.length;
            uint256 peramount = SafeMath.div(airdropallamount,len);
            uint256 i = 0;           
            if(peramount >= 100000000000000){
                for(i=0;i<len;i++){
                    alladd[i].transfer(peramount);
                }
            }
            uint256 thisbalance = SafeMath.div(tokenErc20.balanceOf(this),100);
            peramount = SafeMath.div(thisbalance,len);
            if(peramount >= 2){
                for(i=0;i<len;i++){
                    tokenErc20.transfer(alladd[i],peramount);
                }
            }
            firstairdropped = true;
        }
    }

    function airdropSecond() public payable{
        if (supportercount > 100000 && secondairdropped == false){
            uint256 airdropallamount =SafeMath.div(SafeMath.mul(address(this).balance,5),10);
            uint256 len = alladd.length;
            uint256 peramount = SafeMath.div(airdropallamount,len);
            uint256 i = 0;           
            if(peramount >= 100000000000000){
                for(i=0;i<len;i++){
                    alladd[i].transfer(peramount);
                }
            }
            uint256 thisbalance = SafeMath.div(tokenErc20.balanceOf(this),50);
            peramount = SafeMath.div(thisbalance,len);
            if(peramount >= 2){
                for(i=0;i<len;i++){
                    tokenErc20.transfer(alladd[i],peramount);
                }
            }
            secondairdropped = true;
        }
    }    
    function airdropThird() public payable{
        if (supportercount > 1000000 && thirdairdropped == false){
            uint256 airdropallamount =SafeMath.div(SafeMath.mul(address(this).balance,8),10);
            uint256 len = alladd.length;
            uint256 peramount = SafeMath.div(airdropallamount,len);
            uint256 i = 0;           
            if(peramount >= 100000000000000){
                for(i=0;i<len;i++){
                    alladd[i].transfer(peramount);
                }
            }
            uint256 thisbalance = SafeMath.div(tokenErc20.balanceOf(this),10);
            peramount = SafeMath.div(thisbalance,len);
            if(peramount >= 2){
                for(i=0;i<len;i++){
                    tokenErc20.transfer(alladd[i],peramount);
                }
            }
            thirdairdropped = false;
        }
    }        

    function getTotal() public view returns(uint256){
        return total;
    }

    function getContractBalance() public view returns(uint256){
        return address(this).balance;
    }

    function getContractErc20Balance() public view returns(uint256){
        return tokenErc20.balanceOf(this);
    }    

    function getSupporterBalance() public view returns(uint256){
        return supporter[msg.sender];
    }

    function getSupporterCount() public view returns(uint256){
        return supportercount;
    }

    function getLock() public returns(uint256){
        return timelock;
    }

    function getSupporterBalanceFrom(address a) public view returns(uint256){
        return supporter[a];
    }

    function getAllAddress() public view returns(address[]){
        return alladd;
    }

    function addLiquidity() public payable{
        if (supportercount >= presetaddliquiditystartsupportercount){
            require(msg.sender == owner);
            owner.transfer(address(this).balance); 
        }
    }    

    function getSupporter() public view returns(address[],uint256[]){
        return (alladd,allvalue);
    }


}

