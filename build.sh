#!/usr/bin/env bash
set -eou pipefail

input_redirects="./redirects"
input_rewrites="./rewrites"

apache_output_file="apache/redirects.conf"
nginx_output_file="nginx/redirects.conf"

declare -a a_redirects
declare -a a_rewrites

# ============================================================================
#
# REDIRECT RULES

function convert_redirects() {
  if [[ -f $input_redirects ]]
  then
    echo "Reading input from ${input_redirects}"
    read_redirects
  else
    echo "$input_redirects not found"
  fi

  if [[ ${#a_redirects[@]} -gt 0 ]]
  then
    echo "Converting ${#a_redirects[@]} redirects ..."
    write_redirects
  fi
}

function read_redirects() {
  if [[ -f "${input_redirects}" ]]
  then
    while read -r redirect
    do
      [[ -z $redirect ]] && continue
      a_redirects[${#a_redirects[@]}]="${redirect}"
    done < redirects
  fi
}

function write_redirects() {
  local apache_output="RewriteEngine on\n"
  local nginx_output=""

  for redirect in "${a_redirects[@]}"
  do
    read -a r <<< "$redirect"

    source=${r[0]}
    dest=${r[1]}

    [[ -z $dest ]] && echo "Syntax error in file: destination is blank for source $source" && exit 1

    apache_output+="Redirect 301 $source $dest\n"
    nginx_output+="location $source {\n\t\treturn 301 $dest\n}\n\n"
  done

  echo -e $apache_output > "$apache_output_file"
  echo -e $nginx_output > "$nginx_output_file"
}

# ============================================================================
#
# REWRITE RULES

function convert_rewrites() {
  if [[ -f $input_rewrites ]]
  then
    echo "Reading input from ${input_rewrites}"
    read_rewrites
  else
    echo "$input_rewrites not found"
  fi

  if [[ ${#a_rewrites[@]} -gt 0 ]]
  then
    echo "Converting ${#a_rewrites[@]} rewrites ..."
    write_rewrites
  fi
}

function read_rewrites() {
  if [[ -f "${input_rewrites}" ]]
  then
    while read -r rewrite
    do
      [[ -z $rewrite ]] && continue
      a_rewrites[${#a_rewrites[@]}]="${rewrite}"
    done < rewrites
  fi
}

function write_rewrites() {
  local apache_output=""
  local nginx_output=""

  for rewrite in "${a_rewrites[@]}"
  do
    read -a r <<< "$rewrite"

    source=${r[0]}
    dest=${r[1]}

    [[ -z $dest ]] && echo "Syntax error in file: destination is blank for source $source" && exit 1

    apache_output+="RewriteRule $source $dest [R=301,L]"
    nginx_output+="location ~ $source {\n\t\treturn 301 $dest\n}\n\n"
  done

  echo -e $apache_output >> "$apache_output_file"
  echo -e $nginx_output >> "$nginx_output_file"
}

convert_redirects
convert_rewrites
