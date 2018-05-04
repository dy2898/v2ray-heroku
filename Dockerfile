from nginx:stable-alpine

ENV ID="e92d4093-dbe9-4d6a-b615-e4971ee62fac"  VER=3.19 

COPY conf/ /
ADD entrypoint.sh /entrypoint.sh

RUN apk update \
	&& apk add curl bash supervisor \
	&& mkdir -m 777 /var/log/v2ray \
	&& chmod -R 777 /var/log/ \
	&& touch /run/supervisord.pid \
	&& chmod 777 /run/supervisord.pid \
	&& chmod +x /entrypoint.sh \
	&& touch /var/run/nginx.pid \
	&& chown -R nginx:nginx /var/run/nginx.pid \
	&& chown -R nginx:nginx /var/log/nginx \
	&& chown -R nginx:nginx /etc/nginx/ \
	&& rm -rf /var/cache/apk/* \
	&& curl -L -H "Cache-Control: no-cache" -o v2ray.zip http://github.com/v2ray/v2ray-core/releases/download/v$VER/v2ray-linux-64.zip \
	&& unzip v2ray.zip \
	&& mv ./v2ray-v$VER-linux-64/v2ray /usr/local/bin/ \
	&& mv ./v2ray-v$VER-linux-64/v2ctl /usr/local/bin/ \
	&& chmod +x /usr/local/bin/* \
	&& chmod 777 /etc/ \
	&& chmod 666 /etc/config.json \
	&& rm -rf v2ray.zip \
	&& rm -rf v2ray-v$VER-linux-64 

ENTRYPOINT ["/entrypoint.sh"]
CMD ["v2ray --config /etc/config.json"]
