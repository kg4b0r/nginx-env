FROM nginx:1.15-alpine

MAINTAINER Gabor Koszegi <gabor.koszegi@tert.uk>

ENV DATA_DIR /var/www

ADD start.sh /usr/sbin/

ADD conf /etc/nginx/conf.d/

# adding bash :)
RUN apk add bash

# ensure www-data user exists
RUN set -x ; \
  addgroup -g 82 -S www-data ; \
  adduser -u 82 -D -S -G www-data www-data && exit 0 ; exit 1
RUN apk --no-cache add shadow && usermod -aG www-data nginx
# 82 is the standard uid/gid for "www-data" in Alpine
# http://git.alpinelinux.org/cgit/aports/tree/main/apache2/apache2.pre-install?h=v3.3.2
# http://git.alpinelinux.org/cgit/aports/tree/main/lighttpd/lighttpd.pre-install?h=v3.3.2
# http://git.alpinelinux.org/cgit/aports/tree/main/nginx-initscripts/nginx-initscripts.pre-install?h=v3.3.2

# Disable daemon mode
 # echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
    # Backup configs
RUN    cp -a /etc/nginx/conf.d /etc/nginx/.conf.d.orig && \
    rm -f /etc/nginx/conf.d/default.conf && \
    # Make sure the data directory is created and ownership correct
    mkdir -p $DATA_DIR && \
    chown -R www-data:www-data $DATA_DIR

WORKDIR /etc/nginx

CMD ["/usr/sbin/start.sh"]
