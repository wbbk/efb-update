# ehforwarderbot

> **原始作者文章仓库地址 [jiz4oh/ehforwarderbot](https://github.com/jiz4oh/ehforwarderbot)**，本文在此仓库基础之上新增两个插件，并补充了使用文档。

## 0. 克隆仓库

```shell
git clone https://github.com/wbbk/efb-update efb-update
```

## 1. 编辑配置文件

1. 主配置文件 `efb-update/profiles/default/config.yaml`
    - `middlewares` 定义了启用的转发通道和中间件
        - `catbaron.voice_recog` 语音转文字
        - `patch.PatchMiddleware` 手机微信标记已读
        - 默认启用两个插件，如果不需要某个插件，删除或注释对应的行即可
        - 如果两个都不需要，可以直接删除或注释 `middlewares` 小节

2. Telegram 配置 `efb-update/profiles/default/blueset.telegram/config.yaml`
    - `token` Telegram 的 bot token
    - `admins` Telegram 账号的数字 ID
    - 详情可参考 [efb-wechat-docker 绑定过程记录 | HE-SB-技术栈](https://tech.he-sb.top/posts/usage-of-efbwechat-docker/)

3. wechat 配置 `efb-update/profiles/default/blueset.wechat/config.yaml`
    - 可用的配置及含义参考插件仓库： [ehForwarderBot/efb-wechat-slave](https://github.com/ehForwarderBot/efb-wechat-slave?tab=readme-ov-file#%E5%AE%9E%E9%AA%8C%E5%8A%9F%E8%83%BD)

4. 插件 `catbaron.voice_recog` 配置 `efb-update/profiles/default/catbaron.voice_recog/config.yaml`
    - 配置方法参考插件仓库： [catbaron0/efb-voice_recog-middleware](https://github.com/catbaron0/efb-voice_recog-middleware)

5. 插件 `patch.PatchMiddleware` 配置 `efb-update/profiles/default/patch.PatchMiddleware/config.yaml`
    - `auto_mark_as_read` 是否自动在手机微信标记已读
    - `remove_emoji_in_title` 是否移除 Telegram 群组名称中的 emoji
    - 其他可用配置参考插件仓库： [ehForwarderBot/efb-patch-middleware](https://github.com/ehForwarderBot/efb-patch-middleware)

## 2. 启动容器

### 本地构建后启动

```shell
# 构建镜像efb
docker build efb-update/ -t efb
# 删除容器efb
docker rm -f efb >/dev/null 2>&1 && docker run -d --name=efb --restart=always -v $PWD/profiles:/data/profiles efb
# 容器和镜像同名，是为了方便快速删除和启动，减少 image id 和 container id的查找和使用
```

### 直接使用

```shell
git clone https://github.com/wbbk/efb-update efb-update
cd efb-update
# 参考上文，编辑好配置文件
docker compose up -d
```

## 3. 备份和迁移

容器内所有数据都在 `efb-update/profiles` 路径下，更换机器部署或重建容器时，只需备份这个文件夹，然后挂载进新的容器即可（可参考 `docker-compose.yml` 文件中的挂载方式）。

---

## 4. 参考文章

1. [jiz4oh/ehforwarderbot](https://github.com/jiz4oh/ehforwarderbot)
    - 本镜像原始作者仓库，huge thx！
2. [catbaron0/efb-voice_recog-middleware](https://github.com/catbaron0/efb-voice_recog-middleware)
    - 语音转文字插件仓库
3. [ehForwarderBot/efb-patch-middleware](https://github.com/ehForwarderBot/efb-patch-middleware)
    - EFB 补丁插件仓库
4. [ehForwarderBot/efb-wechat-slave](https://github.com/ehForwarderBot/efb-wechat-slave)
    - 微信通道仓库
5. [Modules Repository · ehForwarderBot/ehForwarderBot Wiki](https://github.com/ehForwarderBot/ehForwarderBot/wiki/Modules-Repository)
    - 官方 wiki，收录了可用的其他插件
    - 其中插件仅验证部分，并已集成到镜像中，其余插件请自行验证可用性
6. [ehForwarderBot 遇到的那些坑 | 松鼠窝](https://blog.shzxm.com/2020/12/31/efb/)
    - 作者为系统直接部署非打包docker镜像，但可参考相关配置和解释
7. [zhangyile/telegram-wechat: 使用 telegram 收发微信](https://github.com/zhangyile/telegram-wechat)
8. [efb-wechat-docker 绑定过程记录 | HE-SB-技术栈](https://tech.he-sb.top/posts/usage-of-efbwechat-docker/)
