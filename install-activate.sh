#!/bin/bash -e
echo "Wait for DB..."

until mysql -h $WORDPRESS_DB_HOST -P 3306 --protocol=tcp -D $WORDPRESS_DB_NAME -u $WORDPRESS_DB_USER -p$WORDPRESS_DB_PASSWORD -e '\q'; do
    >&2 echo "DB is unavailable - sleeping..."
    sleep 2
done

echo "DB is up"

echo "Checking install status"

if ! wp core is-installed; then
    echo "Wordpress already installed! Goodbye..."
    exit 0
fi

echo "Running install..."

wp core install --path="/var/www/html" --url="http://localhost:3030" --title=headless-wordpress --admin_user=wordpress --admin_password=gwen30 --admin_email=john@cajigas.dev --skip-email

echo "Activating plugins..."

wp plugin activate headless-mode --allow-root --path=/var/www/html

wp plugin activate wp-graphql --allow-root --path=/var/www/html

echo "Applying settings..."

wp config set HEADLESS_MODE_CLIENT_URL $HEADLESS_MODE_CLIENT_URL --add

wp rewrite structure '/%postname%/'

echo "Done! Goodbye..."