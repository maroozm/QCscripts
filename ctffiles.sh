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
msg "Checking grid path."

if grep -Rq "rawtf" $name.txt
then
  msg "The path seeems to have rawtf files."
  echo -e "\n Do you want to want to: \n
  [1] discard the rawtf files [Default]\n
  [2] keep the rawtf in the same file \n
  [3] create a new file for rawtf files"
  read -p " Select [1] [2] [3] " -r ans


  if [ "$ans" == "1" ] || [ "$ans" == "" ];
  then
    sed -i '/rawtf/d' $name.txt
    msg "Number of ctf root files: $(sed -n "/ctf/p" "$name.txt" | wc -l)"
  elif [ "$ans" == "2" ];
  then
    msg "Number of rawtf root files: $(sed -n "/rawtf/p" "$name.txt" | wc -l)"
    msg "Number of ctf root files: $(sed -n "/ctf/p" "$name.txt" | wc -l)"
  elif [ "$ans" == "3" ];
  then
    newname=$name
    newname+=rawtf
    sed -n '/rawtf/p' $name.txt >> $newname.txt
    sed -i '/rawtf/d' $name.txt
    msg "Number of rawtf root files: $(sed -n "/rawtf/p" "$name_rawtf.txt" | wc -l)"
    del=$name.txt
    if [ ! -s ${del} ];
    then
      msg "There are no ctf files in the path"
      rm -rf $name.txt
    else
    msg "Number of ctf root files: $(sed -n "/ctf/p" "$name.txt" | wc -l)"
    fi
  fi
else
    msg "Number of ctf root files: $(sed -n "/ctf/p" "$name.txt" | wc -l)"
fi
