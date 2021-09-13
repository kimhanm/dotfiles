#!/usr/bin/bash

[ -f ./files.txt ] && echo -n "files.txt is already present. Overwrite? [y/n]: "

read yesno
if [ $yesno == y ]; then
  ls -1 | sed -n 's/\.png$//p' > files.txt

  for file in $(cat files.txt); do
    convert $file.png $file.jpeg;
  done
fi






