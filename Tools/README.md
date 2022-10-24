# Cosmos node tools
## How to use:

### Setting up(alerts.sh & sendmsg_wechat.js)
* git clone https://github.com/piercezhangx/Cosmos_node.git
* cd Cosmos_node/Tools
* npm install
* open "http://mp.weixin.qq.com/debug/cgi-bin/sandbox?t=sandbox/login" & scan QR code with your wechat
* search how to use wechat interface test account
* replace appId, appSecret, userId and templateId from nodes.txt with your owner datas
* Run ./alerts.sh

## Recommend useage
* set crontab job for alerts.sh
* `*/1 * * * *  /bin/bash $PATH/alerts.sh`

### auto_reward.sh
This is for Cosmos node(Currently only rebus) auto stake script

