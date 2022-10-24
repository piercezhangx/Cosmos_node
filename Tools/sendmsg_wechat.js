const axios = require('axios');
const fs = require('fs');

/**
 * 获取 accessToken
 * @returns accessToken
 */
const getAccessToken = async () => {
  // APP_ID
  const appId = ''
  // APP_SECRET
  const appSecret = ''
  // accessToken
  let accessToken = null

  const postUrl = `https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=${appId}&secret=${appSecret}`

  try {
    const res = await axios.get(postUrl).catch((err) => err)
    if (res.status === 200 && res.data && res.data.access_token) {
      accessToken = res.data.access_token
      console.log('---')
      console.log('获取 accessToken: 成功', res.data)
      console.log('---')
    } else {
      console.log('---')
      console.error('获取 accessToken: 请求失败', res.data.errmsg)
      console.log('---')
      console.log(`40001: 请检查appId，appSecret 填写是否正确；
                  如果第一次使用微信测试号请关闭测试号平台后重新扫码登陆测试号平台获取最新的appId，appSecret`)
    }
  } catch (e) {
    console.error('获取 accessToken: ', e)
  }
  return accessToken
}

//const assembleOpenUrl = () => 'http://weixin.qq.com/download'
const assembleOpenUrl = () => ''

const wxTemplateData = [
  { name: 'body', value: 'Node runs well', color: `#FF99CC` },
]

const sendMessageByWeChatTest = async () => {
  let arguments = process.argv.splice(2)
  var arg1 = arguments[0]
  const userId = ''
  const templateId = ''
  let accessToken = await getAccessToken()

  if (!accessToken) {
    return {
      name: 'self',
      success: false,
    }
  }

  const url = `https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=${accessToken}`
  const data = {
    touser: userId,
    template_id: templateId,
    url: assembleOpenUrl(),
    topcolor: '#FF0000',
    data: {
        "body":{
        "value":arg1,
        "color":"#173177"
        }
    }
  }

  // 发送消息
  const res = await axios.post(url, data, {
    headers: {
      'Content-Type': 'application/json',
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36',
    },
  }).catch((err) => err)

  if (res.data && res.data.errcode === 0) {
    console.log(`推送消息成功`)
    return {
      name: 'self',
      success: true,
    }
  }

  if (res.data && res.data.errcode === 40003) {
    console.error(`推送消息失败! id填写不正确！`)
  } else if (res.data && res.data.errcode === 40036) {
    console.error(`推送消息失败! 模板id填写不正确！`)
  } else {
    console.error(`推送消息失败`, res.data)
  }

  return {
    name: 'self',
    success: false,
  }
}

sendMessageByWeChatTest()
