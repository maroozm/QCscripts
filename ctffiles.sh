#!/usr/bin/env bash

function msg() {
  local text="$1"
  local div_width="80"
  printf "%${div_width}s\n" ' ' | tr ' ' -
  printf "%s\n" "$text"
}

function alienv() {
  if command -v alien.py &>/dev/null; then
    echo ""
  else
    msg "[WARN]: Make sure alienv environment is loaded"
    exit 1
  fi
}

alienv

msg "Please Provide the grid path"
read -p " " -r path

msg "Name the file: {"Enter" for default}"
read -p " " -r answer

if [ "$answer" == "" ];
then
  declare name=$(echo "$path" | awk -F "/" '{print $6}')
else
  declare name=$answer
fi


msg "Creating file for you"

alien_ls $path > $name.txt
sed -i "s+^+alien://$path/+" "$name.txt"

msg "Number of ctf root files: $(wc -l < $name.txt)"
