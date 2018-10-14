console.log(eth.sendTransaction({from:eth.coinbase, to:eth.accounts[1], value: web3.toWei(100, "ether")}));

var block = eth.getBlock("latest");
while(block.gasLimit < 7000000) {
        console.log(eth.sendTransaction({from:eth.coinbase, to:eth.accounts[1], value: web3.toWei(1, "ether")}));
        block = eth.getBlock("latest");
}
