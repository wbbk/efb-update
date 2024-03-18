FROM python:alpine

ENV LANG C.UTF-8
ENV TZ 'Asia/Shanghai'
ENV EFB_DATA_PATH /data/
ENV EFB_PARAMS ""
ENV EFB_PROFILE "default"
ENV HTTPS_PROXY ""

RUN apk add --no-cache tzdata ca-certificates ffmpeg libmagic \
  tiff libwebp freetype lcms2 openjpeg py3-olefile openblas \
  py3-numpy py3-pillow py3-cryptography py3-decorator cairo && \
  apk add --no-cache --virtual .build-deps git build-base gcc && \
  pip install --root-user-action=ignore pysocks ehforwarderbot efb-telegram-master efb-voice_recog-middleware efb-patch-middleware && \
  cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
  apk del .build-deps && \
  apk del tzdata && \
  rm -rf /var/cache/apk/*
RUN pip install --root-user-action=ignore git+https://github.com/ehForwarderBot/efb-wechat-slave.git

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
