FROM debian:bookworm-slim

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# --- set timezone
ARG BUILD_TZ="Europe/Berlin"
RUN echo "$BUILD_TZ" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata
RUN apt-get update && apt-get -y install apt-transport-https lsb-release ca-certificates wget
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" >> /etc/apt/sources.list 

# install packages
RUN apt-get update && \
apt-get --force-yes -y install php5.6-fpm && \
apt-get --force-yes -y install php5.6-mysql && \
apt-get --force-yes -y install php5.6-mcrypt && \
apt-get --force-yes -y install php5.6-xdebug && \
apt-get --force-yes -y install php5.6-mysqlnd && \
apt-get --force-yes -y install php5.6-curl && \
apt-get --force-yes -y install php5.6-json && \
apt-get --force-yes -y install php5.6-ldap && \
apt-get --force-yes -y install php5.6-gd && \
apt-get --force-yes -y install php5.6-memcache && \
apt-get --force-yes -y install php5.6-xml && \
apt-get --force-yes -y install php5.6-mbstring && \
apt-get --force-yes -y install php5.6-mail && \
apt-get --force-yes -y install phpunit


RUN apt-get clean && apt-get -y autoremove  && rm -rf /var/lib/apt/lists/*
RUN rm -rf /usr/share/doc-base /usr/share/doc /usr/share/man

# prepare php-fpm
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g"                     /etc/php/5.6/fpm/php.ini         && \
    sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g"    /etc/php/5.6/fpm/php.ini         && \
    sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g"                /etc/php/5.6/fpm/php.ini         && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g"                        /etc/php/5.6/fpm/php-fpm.conf    && \
    sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_children = 5/pm.max_children = 9/g"                    /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.start_servers = 2/pm.start_servers = 3/g"                  /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g"          /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g"          /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_requests = 500/pm.max_requests = 200/g"                /etc/php/5.6/fpm/pool.d/www.conf && \
    sed -i -e "s|listen = /run/php/php5.6-fpm.sock|listen = 0.0.0.0:9000|g"    /etc/php/5.6/fpm/pool.d/www.conf

# prepare ownership of php-fpm socket file
RUN sed -i -e "s/;listen.mode = 0660/listen.mode = 0750/g" /etc/php/5.6/fpm/pool.d/www.conf && \
    find /etc/php/5.6/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

RUN mkdir -p /run/php  # create directory for socket file

# mycrypt conf
RUN phpenmod mcrypt

# Start Supervisord
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

#
# create directory for service volume
#
RUN mkdir -p /service ; chmod a+rwx /service

ENV TERM xterm
#
# startup script
#
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh
CMD ["/start.sh"]
