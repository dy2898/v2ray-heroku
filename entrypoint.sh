#!/bin/bash
sed -i "s/ID/$ID/g" /etc/config.json
sed -i "s/PORT/$PORT/g" /etc/nginx/conf.d/default.conf

supervisord -c /etc/supervisord.ini
