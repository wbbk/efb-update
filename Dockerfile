FROM python:alpine

ENV LANG C.UTF-8
ENV TZ 'Asia/Shanghai'
ENV EFB_DATA_PATH /data/
ENV EFB_PARAMS ""
ENV EFB_PROFILE "default"
ENV HTTPS_PROXY ""

RUN apk add --no-cache ffmpeg libmagic tiff openjpeg cairo \
  py3-olefile py3-numpy py3-cryptography py3-decorator && \
  cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
  apk del tzdata
RUN apk add --no-cache --virtual .build-deps git build-base && \
  pip install --root-user-action=ignore pysocks ehforwarderbot efb-telegram-master efb-voice_recog-middleware efb-patch-middleware lottie && \
  pip install --root-user-action=ignore git+https://github.com/ehForwarderBot/efb-wechat-slave.git && \
  apk del .build-deps && \
  rm -rf /var/cache/apk/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]