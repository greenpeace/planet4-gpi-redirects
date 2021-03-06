#!/bin/sh

REDIRECTS="redirects"
REWRITES="rewrites"
NGINX_OUT="nginx/redirects.conf"
APACHE_OUT="apache/redirects.conf"

sed -n '
  h
  s_^/_Redirect permanent /_w '"$APACHE_OUT"'
  g
  s/\(.*\)[ 	]\(http.*\)$/location \1 {\
		return 301 \2\
}\
/w '"$NGINX_OUT" "$REDIRECTS"

sed -n '
  /^[ 	]*$/d
  h
  s_^_RedirectMatch permanent _w '"$APACHE_OUT.tmp"'
  g
  s/\(.*\)[ 	]\(http.*\)$/location ~ \1 {\
		return 301 \2\
}\
/w '"$NGINX_OUT.tmp" "$REWRITES"

echo "" >>"$APACHE_OUT" ; cat "$APACHE_OUT.tmp" >>"$APACHE_OUT"
echo "" >>"$NGINX_OUT" ; cat "$NGINX_OUT.tmp" >>"$NGINX_OUT"
rm "$APACHE_OUT.tmp" "$NGINX_OUT.tmp"
