#!/bin/bash
GREEN_COLOR='\033[0;32m'
RED_COLOR='\033[0;31m'
WITHOU_COLOR='\033[0m'
DELEGATOR_ADDRESS='rebus150psuhkxj7s8twqwn705c6tg9k03th6j0u0c6u'
VALIDATOR_ADDRESS='rebusvaloper150psuhkxj7s8twqwn705c6tg9k03th6j3tn80l'
PWD=''
DELAY=1800 #in secs — how often restart the script
ACC_NAME='omega' #example: = ACC_NAME=Wallet30
NODE="tcp://localhost:26657" #change it only if you use another rpc port of your node
CHAIN_NAME="reb_3333-1"
for (( ;; )); do
echo -e "Get reward from Delegation"
echo -e "${PWD}\ny\n" | rebusd tx distribution withdraw-rewards ${VALIDATOR_ADDRESS}  --chain-id ${CHAIN_NAME} --from ${DELEGATOR_ADDRESS} --gas 200000 --commission --yes 
for (( timer=30; timer>0; timer-- ))
do
printf "* sleep for ${RED_COLOR}%02d${WITHOUT_COLOR} sec\r" $timer
sleep 1
done
BAL=$(rebusd q bank balances ${DELEGATOR_ADDRESS} --node ${NODE} -o json | jq -r '.balances | .[].amount')
echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} urebus\n"
echo -e "Claim rewards\n"
echo -e "${PWD}\n${PWD}\n" | rebusd tx distribution withdraw-all-rewards --from ${DELEGATOR_ADDRESS} --chain-id ${CHAIN_NAME} --gas 200000 --yes
for (( timer=30; timer>0; timer-- ))
do
printf "* sleep for ${RED_COLOR}%02d${WITHOU_COLOR} sec\r" $timer
sleep 1
done
BAL=$(rebusd q bank balances ${DELEGATOR_ADDRESS} --node ${NODE} -o json | jq -r '.balances | .[].amount');
echo -e "Balance:${BAL}\n"
echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} urebus\n"
echo -e "Stake ALL\n"
if (( BAL > 0 )); then
echo -e "${PWD}\n${PWD}\n" | rebusd tx staking delegate ${VALIDATOR_ADDRESS} ${BAL}urebus --from ${DELEGATOR_ADDRESS} --gas 200000 --chain-id ${CHAIN_NAME} --yes
else
echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} urebus BAL < 0 ((((\n"
fi
for (( timer=${DELAY}; timer>0; timer--))
do
printf "* sleep for ${RED_COLOR}%02d${WITHOU_COLOR} sec\r" $timer
sleep 1
done
done
