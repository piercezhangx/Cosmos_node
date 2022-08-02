#!/bin/bash
GREEN_COLOR='\033[0;32m'
RED_COLOR='\033[0;31m'
WITHOU_COLOR='\033[0m'
DELEGATOR_ADDRESS=''
VALIDATOR_ADDRESS=''
PWD=''
DELAY=1800 #in secs — how often restart the script
ACC_NAME='' #example: = ACC_NAME=Wallet30
CHAIN_NAME="reb_3333-1"
DENOM='arebus'

for (( ;; )); do
echo -e "Get reward from Delegation"
echo -e "${PWD}\ny\n" | rebusd tx distribution withdraw-rewards ${VALIDATOR_ADDRESS}  --chain-id ${CHAIN_NAME} --from ${DELEGATOR_ADDRESS} --commission --yes 
for (( timer=30; timer>0; timer-- ))
do
printf "* sleep for ${RED_COLOR}%02d${WITHOUT_COLOR} sec\r" $timer
sleep 1
done
BAL=$(rebusd q bank balances ${DELEGATOR_ADDRESS} -o json | jq -r '.balances | .[].amount')
echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} ${DENOM}\n"
echo -e "Claim rewards\n"
echo -e "${PWD}\n${PWD}\n" | rebusd tx distribution withdraw-all-rewards --from ${DELEGATOR_ADDRESS} --chain-id ${CHAIN_NAME} --yes
for (( timer=30; timer>0; timer-- ))
do
printf "* sleep for ${RED_COLOR}%02d${WITHOU_COLOR} sec\r" $timer
sleep 1
done
BAL=$(rebusd q bank balances ${DELEGATOR_ADDRESS} -o json | jq -r '.balances | .[].amount');
echo -e "Balance:${BAL}\n"
echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} ${DENOM}\n"
echo -e "Stake ALL\n"
if (( BAL > 0 )); then
echo -e "${PWD}\n${PWD}\n" | rebusd tx staking delegate ${VALIDATOR_ADDRESS} ${BAL}${DENOM} --from ${DELEGATOR_ADDRESS} --chain-id ${CHAIN_NAME} --yes
else
echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR}  BAL ${DENOM} < 0 ((((\n"
fi
for (( timer=${DELAY}; timer>0; timer--))
do
printf "* sleep for ${RED_COLOR}%02d${WITHOU_COLOR} sec\r" $timer
sleep 1
done
done
