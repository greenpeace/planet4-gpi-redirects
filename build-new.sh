#!/bin/sh

INFILE=redirects-new
NGINX_OUT="nginx/redirects.conf"
APACHE_OUT="apache/.htaccess"

sed -n -e 'h ; s/^\//Redirect permanent /w '"$APACHE_OUT" -e 'g ; s_\(/international/en/\)\(\Whttp\)_ ~ ^\1.*$\2_ ; s/\(.*\)\W\(http.*\)$/location \1 {\n\t\treturn 301 \2\n}\n\n/w '"$NGINX_OUT" <"$INFILE"
