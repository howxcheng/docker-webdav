#!/bin/sh -eux

if [ -n "${WEBDAV_USERNAME:-}" ] && [ -n "${WEBDAV_PASSWORD:-}" ]; then
    htpasswd -cb /etc/nginx/webdavpasswd $WEBDAV_USERNAME $WEBDAV_PASSWORD
else
    echo "No htpasswd config done"
    sed -i 's%auth_basic "Restricted";% %g' /etc/nginx/nginx.conf
    sed -i 's%auth_basic_user_file webdavpasswd;% %g' /etc/nginx/nginx.conf
fi

if [ -n "${PUID:-}" ] && [ -n "${PGID:-}" ]; then
    chmod go+w /dev/stderr /dev/stdout
    gosu $PUID:$PGID mkdir -p /media/.tmp
    exec gosu $PUID:$PGID "$@"
else
    mkdir -p /media/.tmp
    exec "$@"
fi
