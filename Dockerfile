FROM alpine:latest AS builder
RUN apk add --no-cache unzip

WORKDIR /usr/src/tmp

ADD "https://downloads.wordpress.org/plugin/wp-graphql.zip" ./
ADD "https://downloads.wordpress.org/plugin/headless-mode.zip" ./

RUN unzip wp-graphql.zip \
&& rm wp-graphql.zip \
&& unzip headless-mode.zip \
&& rm headless-mode.zip

FROM wordpress:php8.1-apache

WORKDIR /var/www/html

COPY . .
COPY --from=builder /usr/src/tmp/wp-graphql /var/www/html/wp-content/plugins/
COPY --from=builder /usr/src/tmp/headless-mode /var/www/html/wp-content/plugins/


