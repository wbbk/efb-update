# ehforwarderbot

## 安装

```shell
git clone https://github.com/wbbk/efb-update efb-update
```

## 配置

1.  主配置文件 `efb-update/profiles/default/blueset.telegram/config.yaml`
    1. telgram 提供的 bot `token`
    2. telgram 提供的 telgram id `admins`

2.  （可选）插件控制配置文件`efb-update/profiles/default/config.yaml`
    1. 新增插件 catbaron.voice_recog，实现语音转文字；
    2. 新增插件 patch.PatchMiddleware，实现标记微信已读

3. 插件 `catbaron.voice_recog` 配置文件 `ehforwarderbot/profiles/default/catbaron.voice_recog/config.yaml`

    使用api实现语音转文字功能，目前支持配置如下:

    ```yml
    speech_api:
        baidu:
            api_key: API_KEY
            secret_key: SECRET_KEY
            # supported language:
            #   zh, zh-x-en, en, zh-yue, zh-x-sichuan, zh-x-farfield
            lang: zh
        azure:
            key1: KEY_1
            endpoint: ENDPOINT
            # supported language:
            #   ar-EG, ar-SA, ar-AE, ar-KW, ar-QA, ca-ES,
            #   da-DK, de-DE, en-AU, en-CA, en-GB, en-IN,
            #   en-NZ, en-US, es-ES, es-MX, fi-FI, fr-CA,
            #   fr-FR, gu-IN, hi-IN, it-IT, ja-JP, ko-KR,
            #   mr-IN, nb-NO, nl-NL, pl-PL, pt-BR, pt-PT,
            #   ru-RU, sv-SE, ta-IN, te-IN, zh-CN, zh-HK,
            #   zh-TW, th-TH, tr-TR
            lang: zh
        tencent:
            secret_id: SECRET_ID
            secret_key: SECRET_KEY
            # supported language: en, zh
            lang: en
        iflytek:
            app_id: APP_ID
            api_secret: API_SECRET
            api_key: APP_KEY
            # supported language: zh, en
            lang: en
    auto: true
    ```

    建议保留一个使用即可

4. 插件 `patch.PatchMiddleware` 配置文件 `efb-update/profiles/default/patch.PatchMiddleware/config.yaml`

    - 配置文件内容

    ```yml
    auto_mark_as_read: True # 手机微信自动标记已读
    remove_emoji_in_title: True # 移除 Telegram 群组名称中的 emoji
    ```

## 部署

本地构建：

```shell
# 构建镜像efb
docker build efb-update/ -t efb
# 删除容器efb
docker rm -f efb >/dev/null 2>&1 && docker run -d --name=efb --restart=always -v $PWD/profiles:/data/profiles efb
# 容器和镜像同名，是为了方便快速删除和启动，减少 image id 和 container id的查找和使用
```

直接使用：

```shell
git clone https://github.com/wbbk/efb-update efb-update
cd efb-update
# 参考上文，编辑好配置文件
docker compose up -d
```

## 参考文章

原始作者文章仓库地址[jiz4oh/ehforwarderbot](https://github.com/jiz4oh/ehforwarderbot)，本文在此仓库基础之上进行了插件安装，并补充使用文档（原始工具的配置文件有些零散，且有些功能已失效）

[语音转文字插件使用配置](https://github.com/catbaron0/efb-voice_recog-middleware)

[增强 EFB 功能的补丁](https://github.com/ehForwarderBot/efb-patch-middleware)

[blueset.wechat配置文件配置](https://github.com/ehForwarderBot/efb-wechat-slave?tab=readme-ov-file#实验功能)

[可用插件参考地址](https://github.com/ehForwarderBot/ehForwarderBot/wiki/Modules-Repository)（上述插件仅验证部分，并已集成到代码中，其余插件请自行验证可用性）

[ehForwarderBot 遇到的那些坑](https://blog.shzxm.com/2020/12/31/efb/)（作者为系统直接部署非打包docker镜像，可参考相关配置和解释）

## 写在结尾

本文默认省略bot创建，token生成，菜单指令绑定等操作，后续补充，有疑问的可以参考这个文章

[zhangyile/telegram-wechat: 使用 telegram 收发微信 ](https://github.com/zhangyile/telegram-wechat)



efb项目的原理是这样的：
Telegram bot > EFB > 微信网页版 > 微信

使用 itchat-uos 替换了 itchat

- itchat-uos: https://github.com/why2lyj/ItChat-UOS
- itchat: https://github.com/littlecodersh/ItChat

## 环境依赖

- 一个正常使用的 Telegram 账号
- 一个正常使用的微信号 （微信号需实名并绑有银行卡，否则无法登录 UOS 网页版微信）
- docker / docker compose （本文以 docker compose 为例，怎么安装，自己网上找教程）
- 一台 Linux 服务器 （需与 api.telegram.org 能通信）

## Telegram 上创建机器人并获取 Token 和 ID

### 获取 Bot Token

1. 在 Telegram 里, 对 @botfather 说话: /newbot
2. 按照要求给 Bot 取名
3. 获取 Bot Token安全原因: Token 必须保密（这串token要记好，待会要用）
4. 允许 Bot 读取非指令信息，对 @botfather 说话: /setprivacy, 选择disable
5. 允许将 Bot 添加进群组，对 @botfather 说话: /setjoingroups, 选择enable
6. 允许 Bot 提供指令列表，对 @botfather 说话: /setcommands, 输入以下内容 （复制以下内容一次性发给botfather）

```
help - 显示命令列表.
link - 将远程会话绑定到 Telegram 群组
chat - 生成会话头
recog - 回复语音消息以进行识别
info - 显示当前 Telegram 聊天的信息.
unlink_all - 将所有远程会话从 Telegram 群组解绑.
update_info - 更新群组名称和头像
extra - 获取更多功能
```

### 获取 Telegram 账户 ID

再和另外一个机器人 @get_id_bot 对话（也是搜索得到这个机器人），点击 start 即可获得你的 Telegram ID，一串数字（Chat ID）。

至此，Telegram 的配置完成，我们得到两个重要的数字：token、Telegram ID
