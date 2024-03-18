#!/bin/sh

# 判断 tg_group.db 文件是否存在，若不存在则先新建一个
# patch.PatchMiddleware 中间件需要
[ -f "/data/profiles/default/patch.PatchMiddleware/tg_group.db" ] || \
  touch /data/profiles/default/patch.PatchMiddleware/tg_group.db

if [ -n "$EFB_PROFILE" ]; then
  PARAMS="$PARAMS -p $EFB_PROFILE"
fi

PARAMS=

PARAMS="$PARAMS $EFB_PARAMS"

eval "ehforwarderbot $PARAMS"
