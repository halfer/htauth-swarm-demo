# Docker build script for continuous deployment demo container

FROM alpine:3.8

# Install software
RUN apk update
RUN apk add php-cli php-apache2 apache2-utils

# Prep Apache
RUN mkdir -p /run/apache2
RUN echo "ServerName localhost" > /etc/apache2/conf.d/server-name.conf
COPY install/htauth.conf /etc/apache2/conf.d/

# Create password file
RUN htpasswd -bc /etc/apache2/conf.d/htauth.pwd test-user password

# Add dumb init to improve sig handling
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64
RUN chmod +x /usr/local/bin/dumb-init

# Copy shell scripts
COPY bin /app/bin
RUN chmod -R +x /app/bin

# Copy contents of a web dir
RUN rm /var/www/localhost/htdocs/*
COPY web /var/www/localhost/htdocs/
COPY web/secret /var/www/localhost/htdocs/secret

EXPOSE 80

# The healthcheck is used by the Routing Mesh, during a rolling update, to understand
# when to avoid a container that is not ready to receive HTTP traffic.
HEALTHCHECK --interval=5s --timeout=5s --start-period=2s --retries=5 \
    CMD wget -qO- http://localhost/health.php > /dev/null || exit 1

# Start the web server
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["sh", "/app/bin/container-start.sh"]
